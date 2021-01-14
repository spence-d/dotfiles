#On terminals with tmux installed that aren't running it: run tmux
[ -t 1 ] && command -v tmux >/dev/null && [ -z "$TMUX" ] && tmux

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt interactivecomments
autoload -U colors && colors
autoload -Uz compinit && compinit

if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]
then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]
then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]
then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -x "$(command -v mvim)" ]
then
  alias vi="mvim -v"
elif [ -x "$(command -v vim)" ]
then
  alias vi="vim"
fi

[ -x "$(command -v bat)" ] && alias cat="bat"
[ -x "$(command -v batcat)" ] && alias cat="batcat"

[ -x "$(command -v lsd)" ] && alias ls="lsd"
[ -x "$(command -v colorls)" ] && alias ls="colorls"

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

#Integrate vi-style yank/deletions into the OS clipboard
#Causes troubles on SSH, so skip it unless X11 forwarding is available.
if [ -z "$SSH_CLIENT" ] || [ -n "$DISPLAY" ]
then
	kernel=`uname -s`
	case "$kernel" in
		Darwin)
			copy_cmd="pbcopy"
			paste_cmd="pbpaste"
			;;
		Linux)
			copy_cmd="xclip -selection CLIPBOARD"
			paste_cmd="xclip -out -selection CLIPBOARD"
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
fi

##Custom cursor for vi modes
function preexec() {
  echo -n "\033[0 q"
}

function zshexit() {
  echo -n "\033[0 q"
}

function my_precmd() {
  echo -n "\033[6 q"
}
precmd_functions+=(my_precmd)

function zle-keymap-select() {
  if [ "$KEYMAP" = "vicmd" ]
  then
    #Block cursor
    echo -n "\033[0 q"
  elif [ "$ZLE_STATE" = "globalhistory overwrite" ]
  then
    #Underbar cursor
    echo -n "\033[3 q"
  else
    #I-beam cursor
    echo -n "\033[6 q"
  fi
}
zle -N zle-keymap-select

#Allow backspace to go before start of vi insertion
bindkey -v '^?' backward-delete-char

#Gosh I wish Linux would do this automatically, but whenever I reboot my
#computer or replug my keyboard, it fails to map caps lock to esc, so I need
#to run this command.
alias esc="setxkbmap -layout dvorak -option caps:escape"

#cd to the top level of a git repository.
alias cdr='cd $(git rev-parse --show-toplevel)'

#fzf keybindings for zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
#Add Ctrl-Space as a handier alias for Ctrl-T
bindkey '^ ' fzf-file-widget
#Use fd with fzf if available. Faster than find.
if [ -x "$(command -v fd)" ]
then
  export FZF_DEFAULT_COMMAND='fd --type f --color=never'
  export FZF_ALT_C_COMMAND='fd --type d . --color=never'
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/dotfiles/.p10k.zsh ]] || source ~/dotfiles/.p10k.zsh
