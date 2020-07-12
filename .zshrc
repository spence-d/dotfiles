setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt interactivecomments
autoload -U colors && colors
autoload -Uz compinit && compinit

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias vi="mvim -v" cat="bat"
export VISUAL=vi
bindkey -v
export TERM=xterm-256color CLICOLOR=1
export PATH=$PATH:~/bin
export BROWSER=w3m

source ~/wimpline/.wimpline.sh

function vi-kill-eol {
    zle vi-kill-eol-old
    echo "$CUTBUFFER" | pbcopy -i
}

zle -A vi-kill-eol vi-kill-eol-old
zle -N vi-kill-eol

function vi-delete {
    zle vi-delete-old
    echo "$CUTBUFFER" | pbcopy -i
}

zle -A vi-delete vi-delete-old
zle -N vi-delete

function vi-yank {
    zle vi-yank-old
    echo "$CUTBUFFER" | pbcopy -i
}

zle -A vi-yank vi-yank-old
zle -N vi-yank

function vi-put-before {
    CUTBUFFER=$(pbpaste)
    zle vi-put-before-old
}

zle -A vi-put-before vi-put-before-old
zle -N vi-put-before

function vi-put-after {
    CUTBUFFER=$(pbpaste)
    zle vi-put-after-old
}

zle -A vi-put-after vi-put-after-old
zle -N vi-put-after

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
