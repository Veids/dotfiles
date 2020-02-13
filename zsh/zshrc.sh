# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Varibles config
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR=nvim
export FZF_DEFAULT_OPTS="-m --preview='[[ \$(file --mime {}) =~ binary ]] && ( [[ \$(file --mime {}) =~ executable ]] && xxd -l 500 {} || echo {} is a binary ) || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -500' --preview-window='right:hidden:wrap' --bind='f5:toggle-preview'"
export TERM=putty-256color
export GOPATH=$HOME/.go
export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_AUTOQUIT=false
export ZSH_THEME="powerlevel10k/powerlevel10k"
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock.$(hostname)
export VIRTUAL_ENV_DISABLE_PROMPT=1
export VAGRANT_HOME=/vm/vagrant
export CCACHE_DIR=/var/cache/ccache

ZSH=$(antibody path robbyrussell/oh-my-zsh)
source ~/.zsh_plugins.sh

unsetopt beep

# Path setings
typeset -U path
path=(
	"/usr/lib/ccache/bin/"
	$GOPATH/bin
	$HOME/.local/bin
	$path
	$(ruby -e 'puts Gem.user_dir')/bin
)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.go/src/github.com/tomnomnom/gf/gf-completion.zsh ] && source ~/.go/src/github.com/tomnomnom/gf/gf-completion.zsh && unalias gf
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh
