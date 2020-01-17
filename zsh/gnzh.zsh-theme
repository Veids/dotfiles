# Based on bira theme
function preexec() {
  timer=$(date +%s)
}

function _get_runtime() {
  if [ $timer ]; then
    local elapsed=$(($(date +%s) - $timer))
    local minutes=$(($elapsed / 60))
    local sub_seconds=$(($elapsed % 60))
    if [ $minutes -gt 0 ]; then
      local cmd_runtime=$(printf "%dm%ds" $minutes $sub_seconds)
    elif [ $elapsed -gt 0 ]; then
      local cmd_runtime=$elapsed's'
    fi
    unset timer
    if [ $cmd_runtime ]; then
      echo "[$cmd_runtime]"
    fi
  fi
}

function git_time_since_commit() {
  if last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null); then
      now=`date +%s`
      seconds_since_last_commit=$((now-last_commit))

      # Totals
      MINUTES=$((seconds_since_last_commit / 60))
      HOURS=$((seconds_since_last_commit/3600))

      # Sub-hours and sub-minutes
      DAYS=$((seconds_since_last_commit / 86400))
      SUB_HOURS=$((HOURS % 24))
      SUB_MINUTES=$((MINUTES % 60))

      if [[ -n $(git status -s 2> /dev/null) ]]; then
          if [ "$MINUTES" -gt 30 ]; then
              COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
          elif [ "$MINUTES" -gt 10 ]; then
              COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
          else
              COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
          fi
      else
          COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
      fi
      
      if [ "$DAYS" -gt 30 ]; then
          echo "[$COLOR${DAYS}d%{$reset_color%}]"
      elif [ "$HOURS" -gt 24 ]; then
          echo "[$COLOR${DAYS}d${SUB_HOURS}h%{$reset_color%}]"
      elif [ "$MINUTES" -gt 60 ]; then
          echo "[$COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}]"
      else
          echo "[$COLOR${MINUTES}m%{$reset_color%}]"
      fi
  fi
}

function get_nvim_workspace() {
  local session_path=$HOME'/.local/share/nvim/sessions/'
  local pwd="$(pwd | tr / %)"
  if [ -f "${session_path}${pwd}" ]; then
    echo "%{$fg_bold[cyan]%}NVIM%{$reset_color%}%"
  fi
}

function get_virtual_env() {
  # Handle python env
  [ $VIRTUAL_ENV ] && echo "(%{$fg_bold[cyan]%}"$(basename $VIRTUAL_ENV)"%{$reset_color%}%)─"
}

function 

setopt prompt_subst

() {

local PR_USER PR_USER_OP PR_PROMPT PR_HOST

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%f➤ %f'
else # root
  PR_USER='%F{red}%n%f'
  PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➤ %f'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST='%F{red}%M%f' # SSH
else
  PR_HOST='%F{green}%M%f' # no SSH
fi

function _vi_status() {
  if {echo $fpath | grep -q "plugins/vi-mode"}; then
    echo "$(vi_mode_prompt_info)"
  fi
}

local return_code="%(?..%F{red}%? ↵%f)"
local user_host="${PR_USER}%F{cyan}@${PR_HOST}"
local current_dir="%B%F{blue}%~%f%b"
local git_branch='$(git_prompt_info)'

PROMPT="╭─${user_host} ${current_dir} \$(get_nvim_workspace) ${git_branch}
╰─\$(get_virtual_env)$PR_PROMPT "
RPROMPT='$(_get_runtime)$(_vi_status)$(git_time_since_commit) $(git_prompt_status) ${return_code}'

#ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}‹"
#ZSH_THEME_GIT_PROMPT_SUFFIX="› %f"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚑ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}▴ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}◒ "

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[white]%}"

}
