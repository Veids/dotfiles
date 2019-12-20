# Antigen config
source ~/.antigen.zsh

# Varibles config
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR=nvim
export FZF_DEFAULT_OPTS="-m --preview='[[ \$(file --mime {}) =~ binary ]] && ( [[ \$(file --mime {}) =~ executable ]] && xxd -l 500 {} || echo {} is a binary ) || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -500' --preview-window='right:hidden:wrap' --bind='f5:toggle-preview'"
# export MYPYPATH='/usr/local/lib/python3.7/dist-packages'
export TERM=xterm-256color
export PATH="$HOME/.local/bin:$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_AUTOQUIT=false

# Aliases

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

plugins=(
  vagrant
)

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle colored-man-pages
antigen bundle tmux
antigen bundle timer


# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
# antigen bundle Piping/fzf-zsh
antigen bundle zsh-users/zsh-autosuggestions
# lxd/lxc completion
antigen bundle endaaman/lxd-completion-zsh

# Load the theme.
antigen theme gnzh

antigen apply
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# bindkey -v
