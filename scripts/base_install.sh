#!/bin/bash

# Install stow
yay -S --noconfirm --needed stow

# Install Zsh
if ! command -v zsh &>/dev/null; then
    yay -S --noconfirm --needed zsh
fi

# Install Zap (minimal Zsh plugin manager)
if [ ! -f "${HOME}/.local/share/zap/zap.zsh" ]; then
    echo "Installing Zap..."
    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --keep
else
    echo "Zap is already installed."
fi

# Install Zen Browser
if ! command -v zen &>/dev/null; then
    yay -S --noconfirm --needed zen-browser-bin
fi

# Install VSCode
if ! command -v code &>/dev/null; then
    yay -S --noconfirm --needed visual-studio-code-bin
fi
