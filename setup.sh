#!/bin/bash

sudo dnf install -y i3 neovim tmux stow alacritty rofi flameshot fd-find bat

if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
fi

mkdir -p ~/.tmux/plugins
[ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
[ ! -d ~/.tmux/plugins/tmux-resurrect ] && git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect  
[ ! -d ~/.tmux/plugins/tmux-continuum ] && git clone https://github.com/tmux-plugins/tmux-continuum ~/.tmux/plugins/tmux-continuum

stow bashrc nvim i3 tmux
