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
        lazygit

elif [[ -f /etc/fedora-release ]]; then
    echo "Detected Fedora - using dnf..."

    sudo dnf install -y \
        tldr \
        eza \
        fzf \
        zoxide \
        starship \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        lazygit

else
    echo "Unsupported OS. Add support for your package manager."
    exit 1
fi

echo "Updating tldr cache..."
tldr --update

echo "Done!"
