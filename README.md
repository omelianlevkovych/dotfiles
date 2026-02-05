# Dotfiles

Cross-platform dotfiles for macOS and Fedora Linux.

## Quick Start

```bash
# Clone the repo
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Install packages (Homebrew on macOS, dnf on Fedora)
./install.sh

# Create symlinks
./link.sh
```

## What Gets Linked

| Source | Target |
|--------|--------|
| `~/dotfiles/.zshrc` | `~/.zshrc` |
| `~/dotfiles/starship.toml` | `~/.config/starship.toml` |
| `~/dotfiles/kitty` | `~/.config/kitty` |
| `~/dotfiles/.gitconfig` | `~/.gitconfig` |

## Git Configuration

The `.gitconfig` uses an include-based approach for machine-specific settings:

- **Shared settings** are in `~/dotfiles/.gitconfig` (tracked in git)
- **Personal settings** go in `~/.gitconfig.local` (not tracked)

On first run, `link.sh` will:
1. Extract your existing `user.name` and `user.email`
2. Create `~/.gitconfig.local` with those values
3. Symlink the shared config

For new machines, copy the example:
```bash
cp ~/dotfiles/.gitconfig.local.example ~/.gitconfig.local
# Then edit with your name/email
```

## Installed Tools

- tldr
- eza
- fzf
- zoxide
- starship
- zsh-autosuggestions
- zsh-syntax-highlighting
- lazygit
- bat
- ripgrep
- fd

## Backups

When `link.sh` runs, existing files are backed up to `~/dotfiles/backups/` with timestamps. The script is idempotent—safe to run multiple times.
