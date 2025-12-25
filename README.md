# Automated Configuration Setup
Hi 👋 Here is my .dotfiles with config for different application for quickly and automatically setup my development environment. So if you like something feel free to check it out here.

## Setup All dotfiles:
> [!IMPORTANT]  Clone the dotfile repo to '~' (home) directory
```bash
stow .
```

## Install Omarchy Setup Scripts:
To automatically install all components, clone the repository to your home directory and run the installation script (assumes Arch Linux with yay available):
```bash
cd ~/dotfiles/scripts
chmod +x install-all.sh
./install-all.sh
```

This script will:
- Install base packages (stow, zsh, Zen Browser, Visual Studio Code)
- Install and set up tmux with Tmux Plugin Manager (TPM)
- Clone the dotfiles repository (if not already cloned) and stow the configurations
- Set up Hyprland overrides by sourcing the configuration file
- Set Zsh as the default shell

You can also run individual scripts for specific components:
- `./base_install.sh`: Installs base dependencies (stow, zsh, Zen Browser, Visual Studio Code)
- `./tmux_install.sh`: Installs tmux and TPM
- `./install_dotfiles.sh`: Clones the repository and stows dotfiles (removes old nvim configs)
- `./install_overrides.sh`: Sets up Hyprland overrides by appending a source line to ~/.config/hypr/hyprland.conf
- `./set_shell.sh`: Sets Zsh as the default shell for the current user
