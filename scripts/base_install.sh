#!/bin/bash

# Install stow
yay -S --noconfirm --needed stow

# Install hyprswitch (Hyprland window switcher/launcher)
if ! command -v hyprswitch &>/dev/null; then
    echo "Installing hyprswitch..."
    yay -S --noconfirm --needed hyprswitch
else
    echo "hyprswitch is already installed."
fi

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

# Install and setup Atuin (local-only, no sync or account)
if ! command -v atuin &>/dev/null; then
    echo "Installing Atuin (local-only mode)..."
    bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
    
    echo "Importing existing shell history into Atuin..."
    
else
    echo "Atuin is already installed."
fi
