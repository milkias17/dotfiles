# Env variables
set -Ux TERMINAL kitty
set -Ux EDITOR nvim
set -Ux BROWSER firefox
set -U fish_user_paths $HOME/{'', '.local/'}bin/ /opt/appimages/

# Fix resizing issues
set --unexport {COLUMNS,LINES}

# Aliases
alias check="ping google.com"
alias c="clear"

if test "$TERM" = xterm || test "$TERM" = linux
    alias ll="ls -l"
    alias la="ls -a"
    alias l="ls -F"
    alias lla="ls -la"
else
    alias ls="lsd"
    alias ll="lsd -l"
    alias la="lsd -a"
    alias l="lsd -F"
    alias lt="lsd --tree"
    alias lla="lsd -la"
end

alias v="nvim"
alias vim="nvim"
alias pai="sudo pacman -S"
alias par="sudo pacman -Rns"
alias pau="sudo pacman -Syu"
alias pas="pacman -Ss"
alias info="pacman -Si"
alias yi="yay -S"
alias yr="yay -Rns"
alias yu="yay -Syu"
alias ys="yay -Ss"
alias window="xprop | grep -i 'class'"
alias cleanup="sudo pacman -Rns (pacman -Qtdq)"
alias gc="git clone"
alias ..="cd .."
alias grep="grep --color=auto"
alias wget="wget -c"

function zeal-docs-fix
    pushd "$HOME/.local/share/Zeal/Zeal/docsets" >/dev/null || return
    find . -iname 'react-main*.js' -exec rm '{}' \;
    popd >/dev/null || exit
end

export FZF_DEFAULT_COMMAND='rg --files --follow --hidden -g "!{node_modules/*,.git/*,__pycache__/*,env/*}"'
