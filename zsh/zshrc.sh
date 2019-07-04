# Antigen config
source ~/.antigen.zsh

# Varibles config
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export TZ='Asia/Yekaterinburg'
export BIONIC=~/chroots/bionic
export XENIAL=~/chroots/xenial
export EDITOR=nvim
export FZF_DEFAULT_OPTS="-m --preview='[[ \$(file --mime {}) =~ binary ]] && ( [[ \$(file --mime {}) =~ executable ]] && xxd -l 500 {} || echo {} is a binary ) || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -500' --preview-window='right:hidden:wrap' --bind='f5:toggle-preview'"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle colored-man-pages

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
# antigen bundle leophys/zsh-plugin-fzf-finder
#
# #
source ~/.fzf/shell/completion.zsh
source ~/.fzf/shell/key-bindings.zsh
# antigen bundle Piping/fzf-zsh
antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
#antigen theme trapd00r 
antigen theme gnzh
#antigen theme bureau
## Tell Antigen that you're done.
antigen apply

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
