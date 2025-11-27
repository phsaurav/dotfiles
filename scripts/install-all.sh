#!/bin/bash

# Install all packages in order
./base_install.sh
./tmux_install.sh
./install_dotfiles.sh
./install_overrides.sh

./set_shell.sh
