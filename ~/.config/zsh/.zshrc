PROMPT="%F{green}%~%f %F{magenta}%?%f %B>>%b "

autoload -U colors && colors
autoload -U compinit promptinit

zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots)
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
setopt autocd
unsetopt beep
autoload -Uz run-help
(( ${+aliases[run-help]} )) && unalias run-help
alias help=run-help
promptinit;
bindkey -e

use_zathura() {
    zathura $* & disown && kill $(ps -p $$ -o ppid=)
}

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias ln='ln -v'
alias grep="grep --color=auto"
alias vi='nvim'
alias vim='nvim'
alias ls='ls -XAhl --group-directories-first --color=auto'
alias sl='ls -XAhl --group-directories-first --color=auto'
alias exiit='exit'
alias wttr='curl -s wttr.in | grep -v "Follow"'
alias sxiv='sxiv -a'
alias du='du -h'
alias uptime='uptime -p'
alias diff='diff -u'
alias claer='clear'
alias cp='cp -r'
alias emacs='emacs -nw'
alias icat='kitty +kitten icat'
alias yt-dlp-music='yt-dlp -x --embed-metadata --embed-thumbnail --parse-metadata ":(?P<meta_comment>)" --audio-format m4a -o "%(title)s.%(ext)s"'
alias open="xdg-open"
alias tree="tree -C"
source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
