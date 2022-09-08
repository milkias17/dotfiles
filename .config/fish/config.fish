if not status is-interactive
    return
end

# Env variables
set -Ux TERMINAL kitty
set -Ux EDITOR nvim
set -Ux BROWSER firefox
set -U fish_user_paths $HOME/{'', '.local/', 'go/', '.cargo/'}bin/ $HOME/.local/share/coursier/bin /opt/appimages/ $HOME/Documents/Apps/flutter/bin $HOME/Documents/Apps/android-studio/bin $HOME/.deta/bin
set -Ux FZF_DEFAULT_COMMAND "rg -g '!{**/node_modules/*,**/.git/*,**/env/*}' --files"

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
# alias ai="sudo apt install"
# alias ar="sudo apt purge"
# alias au="sudo apt update && sudo apt upgrade"
# alias as="apt search"
# alias ac="sudo apt autoremove"
alias ai="sudo nala install"
alias ar="sudo nala purge"
alias au="sudo nala upgrade"
alias as="nala search"
alias ac="sudo nala autoremove"
alias info="apt info"
alias grep="grep --color=auto"
alias gc="git clone"
alias ..="cd .."

function zeal-docs-fix
    pushd "$HOME/.local/share/Zeal/Zeal/docsets" >/dev/null || return
    find . -iname 'react-main*.js' -exec rm '{}' \;
    popd >/dev/null || exit
end
