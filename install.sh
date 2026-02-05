#!/bin/bash
# Dotfiles package installer for macOS and Fedora

set -e

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS - using Homebrew..."

    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Install it first:"
        echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
    fi

    brew install \
        tldr \
        eza \
        fzf \
        zoxide \
        starship \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        zsh-completions \
        lazygit \
        bat \
        ripgrep \
	fd

elif [[ -f /etc/fedora-release ]]; then
    echo "Detected Fedora - using dnf..."

    # Enable COPR repos for packages not in default repos
    sudo dnf copr enable -y atim/starship
    sudo dnf copr enable -y dejan/lazygit
    sudo dnf copr enable -y @zsh-users/zsh-completions

    sudo dnf install -y \
        tldr \
        fzf \
        zoxide \
        starship \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        zsh-completions \
        lazygit \
        bat \
        ripgrep \
        cargo \
	fd

    # Add cargo bin to PATH for this session
    export PATH="$HOME/.cargo/bin:$PATH"

    # eza not in Fedora repos, install via cargo
    if ! command -v eza &> /dev/null; then
        echo "Installing eza via cargo..."
        cargo install eza
    fi

    # Ensure cargo bin is in PATH permanently
    if ! grep -q '.cargo/bin' ~/.zshrc 2>/dev/null; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
        echo "Added cargo bin to ~/.zshrc"
    fi

else
    echo "Unsupported OS. Add support for your package manager."
    exit 1
fi

echo "Updating tldr cache..."
tldr --update

echo "Done!"
