# Env variables
set -Ux TERMINAL kitty
set -Ux EDITOR nvim
set -Ux BROWSER firefox
set -U fish_user_paths $HOME/bin/ $HOME/.local/bin/ /opt/appimages/

# Aliases
alias check="ping google.com"
alias c="clear"
alias ls="lsd"
alias ll="lsd -l"
alias la="lsd -a"
alias l="lsd -F"
alias lt="lsd --tree"
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
alias grep="grep --color=auto"
alias ..="cd .."

thefuck --alias | source

function zeal-docs-fix
    pushd "$HOME/.local/share/Zeal/Zeal/docsets" >/dev/null || return
    find . -iname 'react-main*.js' -exec rm '{}' \;
    popd >/dev/null || exit
end
