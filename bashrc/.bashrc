# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# fd = faster than find
# also avoid junk like directories or stuff inside .git
# and show hidden files
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# have fzf use fd by default
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# show file contents with syntax highlighting when hovering over files
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} 2> /dev/null | head -500'"

# fzf w/ preview window for any file
alias ff='fzf --preview "bat --style=numbers --color=always {}"'

# Override Alt+C with better directory finder
bind '"\ec": " \C-e\C-ucd \"\$(fd --type d --hidden --follow --exclude .git | fzf)\"\e\C-e\er\C-m"'

# interactively select and kill a process
alias fkill='kill $(ps aux | fzf | awk "{print \$2}")'

# switch branches
alias gco='git checkout $(git branch | fzf)'

# pick a commit from history and see its changes
alias gshow='git show $(git log --oneline | fzf | cut -d" " -f1)'

# interactively select files to stage
alias gadd='git add $(git diff --name-only | fzf -m)'

# styling
export FZF_DEFAULT_OPTS='--height 40% --border --color=16'
