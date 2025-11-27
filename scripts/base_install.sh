#!/bin/bash
# Install stow
yay -S --noconfirm --needed stow
# Install Zsh
if ! command -v zsh &>/dev/null; then
    yay -S --noconfirm --needed zsh
fi
# Install Zen Browser
if ! command -v zen &>/dev/null; then
    yay -S --noconfirm --needed zen-browser-bin
fi
# Install VSCode
if ! command -v code &>/dev/null; then
    yay -S --noconfirm --needed visual-studio-code-bin
fi
