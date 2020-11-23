setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt interactivecomments
autoload -U colors && colors
autoload -Uz compinit && compinit

if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]
then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -x "$(command -v mvim)" ]
then
    alias vi="mvim -v"
elif [ -x "$(command -v vim)" ]
then
    alias vi="vim"
fi

[ -x "$(command -v bat)" ] && alias cat="bat"
[ -x "$(command -v lsd)" ] && alias ls="lsd"
[ -x "$(command -v dust)" ] && alias du="dust"

export VISUAL=vi
bindkey -v
export TERM=xterm-256color CLICOLOR=1
export PATH=$PATH:~/bin
export BROWSER=w3m
export XDG_CONFIG_HOME=~/dotfiles/.config/

if [ -f ~/wimpline/.wimpline.sh ]
then
    source ~/wimpline/.wimpline.sh
else
    PROMPT="%B%(?.%F{green}.%F{red})%h%b:%f %F{magenta}%*%f %F{yellow}%m:%B%25<…<%~%b%f%# "
fi

kernel=`uname -s`
case "$kernel" in
    Darwin)
        copy_cmd="pbcopy"
        paste_cmd="pbpaste"
        ;;
    Linux)
        ;;
    Haiku)
        copy_cmd="clipboard -i"
        paste_cmd="clipboard -p"
        ;;
esac

function vi-kill-eol {
    zle vi-kill-eol-old
    echo "$CUTBUFFER" | eval $copy_cmd
}

zle -A vi-kill-eol vi-kill-eol-old
zle -N vi-kill-eol

function vi-delete {
    zle vi-delete-old
    echo "$CUTBUFFER" | eval $copy_cmd
}

zle -A vi-delete vi-delete-old
zle -N vi-delete

function vi-yank {
    zle vi-yank-old
    echo "$CUTBUFFER" | eval $copy_cmd
}

zle -A vi-yank vi-yank-old
zle -N vi-yank

function vi-put-before {
    CUTBUFFER=$(eval $paste_cmd)
    zle vi-put-before-old
}

zle -A vi-put-before vi-put-before-old
zle -N vi-put-before

function vi-put-after {
    CUTBUFFER=$(eval $paste_cmd)
    zle vi-put-after-old
}

zle -A vi-put-after vi-put-after-old
zle -N vi-put-after

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
