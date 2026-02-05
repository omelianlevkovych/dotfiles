#!/bin/bash
# Dotfiles symlink manager - creates symlinks for all config files
# Safe to run multiple times (idempotent)

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$DOTFILES_DIR/backups"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macOS"
elif [[ -f /etc/fedora-release ]]; then
    PLATFORM="Fedora"
else
    PLATFORM="Linux"
fi

echo "Dotfiles Symlink Manager"
echo "========================"
echo "Platform: $PLATFORM"
echo "Dotfiles: $DOTFILES_DIR"
echo "Config:   $CONFIG_DIR"
echo ""

# Ensure directories exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$CONFIG_DIR"

# Backup a file if it exists and is not a symlink
backup_if_exists() {
    local target="$1"
    local name=$(basename "$target")

    if [[ -e "$target" && ! -L "$target" ]]; then
        local backup_path="$BACKUP_DIR/${name}.${TIMESTAMP}"
        echo "  Backing up $target -> $backup_path"
        mv "$target" "$backup_path"
    elif [[ -L "$target" ]]; then
        # Remove existing symlink
        rm "$target"
    fi
}

# Create a symlink
create_link() {
    local source="$1"
    local target="$2"

    if [[ ! -e "$source" ]]; then
        echo "  SKIP: Source does not exist: $source"
        return
    fi

    # Check if already correctly linked
    if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        echo "  OK: $target (already linked)"
        return
    fi

    backup_if_exists "$target"

    # Ensure parent directory exists
    mkdir -p "$(dirname "$target")"

    ln -s "$source" "$target"
    echo "  LINK: $target -> $source"
}

# Handle .gitconfig with include-based approach
setup_gitconfig() {
    echo ""
    echo "Setting up .gitconfig..."

    local source="$DOTFILES_DIR/.gitconfig"
    local target="$HOME/.gitconfig"
    local local_config="$HOME/.gitconfig.local"

    # Extract user info from existing .gitconfig if it exists and .gitconfig.local doesn't
    if [[ -f "$target" && ! -L "$target" && ! -f "$local_config" ]]; then
        local user_name=$(git config --global user.name 2>/dev/null || echo "")
        local user_email=$(git config --global user.email 2>/dev/null || echo "")

        if [[ -n "$user_name" || -n "$user_email" ]]; then
            echo "  Creating $local_config with existing user info..."
            cat > "$local_config" << EOF
[user]
    name = $user_name
    email = $user_email
EOF
            echo "  Created .gitconfig.local with:"
            echo "    name: $user_name"
            echo "    email: $user_email"
        fi
    fi

    # Create the symlink
    create_link "$source" "$target"

    # Remind about .gitconfig.local if it doesn't exist
    if [[ ! -f "$local_config" ]]; then
        echo ""
        echo "  NOTE: Create ~/.gitconfig.local with your user info:"
        echo "    [user]"
        echo "        name = Your Name"
        echo "        email = your@email.com"
    fi
}

echo "Creating symlinks..."

# ~/.zshrc
create_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# ~/.config/starship.toml
create_link "$DOTFILES_DIR/starship.toml" "$CONFIG_DIR/starship.toml"

# ~/.config/kitty
create_link "$DOTFILES_DIR/kitty" "$CONFIG_DIR/kitty"

# zsh-history-substring-search (platform-specific source)
echo ""
echo "Setting up zsh-history-substring-search..."
HSSS_TARGET="$HOME/.local/share/zsh-history-substring-search"
if [[ "$PLATFORM" == "macOS" ]]; then
    create_link "/opt/homebrew/share/zsh-history-substring-search" "$HSSS_TARGET"
elif [[ -d "$HSSS_TARGET" && ! -L "$HSSS_TARGET" ]]; then
    # Fedora: cloned directly by install.sh, nothing to link
    echo "  OK: $HSSS_TARGET (installed directly)"
fi

# ~/.gitconfig (special handling)
setup_gitconfig

echo ""
echo "Done!"
echo ""
echo "Verification:"
echo "  ls -la ~/.zshrc ~/.gitconfig ~/.config/starship.toml ~/.config/kitty"
