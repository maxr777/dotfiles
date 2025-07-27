#!/bin/bash

sudo dnf install -y i3 neovim tmux stow alacritty rofi flameshot fd-find bat xinput

if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
fi

mkdir -p ~/.tmux/plugins
[ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
[ ! -d ~/.tmux/plugins/tmux-resurrect ] && git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect  
[ ! -d ~/.tmux/plugins/tmux-continuum ] && git clone https://github.com/tmux-plugins/tmux-continuum ~/.tmux/plugins/tmux-continuum

backup_dir=~/dotfiles_backup_$(date +%Y%m%d_%H%M%S)

backup_if_exists() {
    local source="$1"
    local name="$2"
    
    if [ -e "$source" ]; then
        echo "Backing up existing $name..."
        mkdir -p "$backup_dir"
        mv "$source" "$backup_dir/"
        return 0
    fi
    return 1
}

backup_if_exists ~/.bashrc "bashrc"
backup_if_exists ~/.config/nvim "nvim config"
backup_if_exists ~/.config/i3 "i3 config" 
backup_if_exists ~/.tmux.conf "tmux config"
backup_if_exists ~/.config/alacritty "alacritty config"

[ -d "$backup_dir" ] && echo "Existing configs backed up to: $backup_dir"

stow bashrc nvim i3 tmux alacritty
