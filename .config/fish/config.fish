# Env variables
set -Ux TERMINAL kitty
set -g EDITOR nvim
set -Ux BROWSER firefox
set -U fish_user_paths $HOME/{'', '.local/', 'go/', '.cargo/', '.bun/'}bin/ $HOME/.local/share/coursier/bin /opt/appimages/ $HOME/Documents/Apps/flutter/bin $HOME/Documents/Apps/android-studio/bin $HOME/.deta/bin
set -Ux FZF_DEFAULT_COMMAND "rg -g '!{**/node_modules/*,**/.git/*,**/env/*}' --files"
# set -Ux FZF_DEFAULT_OPTS "\
# --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
# --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Aliases
alias check="ping google.com"
alias c="clear"

if test "$TERM" = xterm || test "$TERM" = linux || not type -q lsd
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
alias di="sudo dnf install"
alias dr="sudo dnf remove"
alias au="sudo apt update && sudo apt upgrade"
alias dnu="sudo dnf upgrade"
alias ds="sudo dnf search"
alias dc="sudo dnf autoremove"
alias info="dnf info"
alias grep="grep --color=auto"
alias ..="cd .."
alias kg="kitty +kitten hyperlinked_grep --smart-case"
alias icat="kitty +kitten icat"
alias ggc="git clone"
alias ggs="git status"
alias ggl="git log"
alias pc="protonvpn-cli c -f"

function zeal-docs-fix
    pushd "$HOME/.local/share/Zeal/Zeal/docsets" >/dev/null || return
    find . -iname 'react-main*.js' -exec rm '{}' \;
    popd >/dev/null || exit
end
