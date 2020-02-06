# Based on bira theme
function preexec() {
  timer=$(date +%s)
}

function precmd() {
  if [ $timer ]; then
    unset cmd_runtime
    local elapsed=$(($(date +%s) - $timer))
    local days=$((elapsed / 86400))
    local hours=$((elapsed % 86400 / 3600))

    if [ $days -gt 0 ]; then
      cmd_runtime="${days}d${hours}h"
    else
      local minutes=$(($elapsed % 3600 / 60))
      if [ $hours -gt 0 ]; then
        cmd_runtime="${hours}h${minutes}m"
      else
        local seconds=$(($elapsed % 60))
        if [ $minutes -gt 0 ]; then
          cmd_runtime="${minutes}m${seconds}s"
        elif [ $elapsed -gt 0 ]; then
          cmd_runtime=$elapsed's'
        fi
      fi
    fi

    unset timer
    if [ $cmd_runtime ]; then
      cmd_runtime="[ $cmd_runtime ⏳]"
    fi
  else
    unset cmd_runtime
  fi
}

function
setopt prompt_subst
() {
  # Supplementary functions
  function eval_len_array() {
    local full=0
    _res=()
    for x in ${1[@]}; do
      eval res=$x
      _res+=("$res")
      if [ $res ]; then
        full=$(($full + $2))
      fi
    done
    echo $_res
    return $full
  }

  function rprompt_builder() {
    function left()  echo "%{$(echotc LEFT $1)%}"
    function right() echo "%{$(echotc RIGHT $1)%}"
    local __supl_size=7

    eval __r1=$r1prompt
    __r2=$(eval_len_array $r2prompt $__supl_size)
    __sub_len=$?

    build=""
    if [ $__r1 ]; then
      build="%{$(echotc UP 1)%}"
      if [ $__r2 ]; then
        local __len=$(($(expr length $__r2)-$__sub_len))
        build+="$(right $__len)"
        build+=$__r1
        build+="$(left $__len)"
        build+="%{$(echotc DOWN 1)%}"
        build+=$__r2
      else
        build+=$__r1
        build+="%{$(echotc DOWN 1)%}"
      fi
    else
      build+=$__r2
    fi
    echo $build
  }

  # Status functions
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
    [ -f "${session_path}$(pwd | tr / %)" ] && echo "%F{c}NVIM%f"
  }

  function get_virtual_env() {
    # Handle python env
    [ $VIRTUAL_ENV ] && echo "(%{$fg_bold[green]%}\U1F40D%{$fg_bold[green]%}"$(basename $VIRTUAL_ENV)"%{$reset_color%}%)─"
  }

  function vi_status() {
    if {echo $fpath | grep -q "plugins/vi-mode"}; then
      echo "$(vi_mode_prompt_info)"
    fi
  }

  function stive_jobs() {
    local __len=$(jobs | wc -l)
    if [ $__len -gt 0 ]; then
      echo "[ %F{yellow}$__len⚙%f ]"
    fi
  }

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

  local return_code="%(?..%F{red}%? ↵%f)"
  local user_host="${PR_USER}%F{cyan}@${PR_HOST}"
  local current_dir="%B%F{blue}%~%f%b"
  local git_branch='$(git_prompt_info)'
  # local jobs="%(1j.[%F{yellow}%j⚙%f].)"

  PROMPT="╭─${user_host} ${current_dir} ${git_branch} \$(git_time_since_commit)
╰─\$(get_virtual_env)$PR_PROMPT "
  

  r1prompt=(
    "\${cmd_runtime}"
    "\$(vi_status)"
    "\$(stive_jobs)"
  )
  r1prompt="${(j::)r1prompt}"
  r2prompt=(
    "\$(get_nvim_workspace)"
  )

  RPROMPT='$(rprompt_builder)'
  # RPROMPT=$R1PROMPT

  #ZSH GIT PROMPT COLLORS SETUP
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
