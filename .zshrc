#On non-SSH terminals with tmux installed that aren't running it: run tmux
[ -t 1 ] && [ -z "$SSH_CLIENT" ] && command -v tmux >/dev/null && [ -z "$TMUX" ] && tmux

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#Mimics bash's behavior of hiding commands with a leading space from history
setopt HIST_IGNORE_SPACE

setopt AUTO_CD
setopt HIST_IGNORE_DUPS
HISTSIZE=900
SAVEHIST=900
setopt interactivecomments
autoload -U colors && colors
autoload -Uz compinit && compinit

if [ -f /usr/share/z/z.sh ]
then
  source /usr/share/z/z.sh
fi

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
#Shift-Tab will accept the suggestion and run it.
bindkey '^[[Z' autosuggest-execute

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
#Shell comments are (bafflingly) invisible by default
ZSH_HIGHLIGHT_STYLES[comment]=fg=59

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
[ -x "$(command -v exa)" ] && alias ls="exa --icons --git"
alias tree='ls --tree'
[ -x "$(command -v exa)" ] && alias tree="exa --icons --tree"

[ -x "$(command -v dust)" ] && alias du="dust"

[ -x "$(command -v procs)" ] && alias ps="procs"
[ -x "$(command -v htop)" ] && alias top="htop"

export VISUAL=vim
bindkey -v
export TERM=xterm-256color CLICOLOR=1
export PATH=$PATH:~/bin
export BROWSER=vivaldi-stable
export XDG_CONFIG_HOME=~/dotfiles/.config/
#Make the scroll wheel work when the pager runs in tmux
#Allow terminal colors
#Don't run pager if there's nothing to scroll
#Ctrl-C quits
export LESS="--mouse --RAW-CONTROL-CHARS --quit-if-one-screen --quit-on-intr"
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
		CUTBUFFER=$(eval $paste_cmd 2> /dev/null)
		zle vi-put-before-old
	}

	zle -A vi-put-before vi-put-before-old
	zle -N vi-put-before

	function vi-put-after {
		CUTBUFFER=$(eval $paste_cmd 2> /dev/null)
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
#Delete, Home, and End keys are broken by default
bindkey '^[[3~' delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
#vim normal mode H and L behave like ^ and $
bindkey -a 'H' beginning-of-line
bindkey -a 'L' end-of-line
#Previous and next command in insert mode
bindkey '^P' up-history
bindkey '^N' down-history

#Ctrl-V will open the current line in vim
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^V" edit-command-line
bindkey -M vicmd "^V" edit-command-line

#cd to the top level of a git repository.
alias cdr='cd $(git rev-parse --show-toplevel)'

#fzf keybindings for zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
#Add Ctrl-Space as a handier alias for Ctrl-T
bindkey '^ ' fzf-file-widget
#Use fd with fzf if available. Faster than find.
if [ -x "$(command -v fd)" ]
then
  export FZF_DEFAULT_COMMAND='fd --type f --color=never'
  export FZF_ALT_C_COMMAND='fd --type d . --color=never'
fi

fzf-greenclip-widget() {
  LBUFFER="${LBUFFER}$(greenclip print | sed '/^$/d' | fzf -e)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   fzf-greenclip-widget
bindkey '^X' fzf-greenclip-widget

#Enable tab-completion menu
zstyle ':completion:*' menu select
zmodload zsh/complist
#Use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/dotfiles/.p10k.zsh ]] || source ~/dotfiles/.p10k.zsh

export ZLE_RPROMPT_INDENT=0

#Prevent execute-named-cmd, which is useless, easy to enter, and difficult to escape from
bindkey -a -r ':'
