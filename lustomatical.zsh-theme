# Depends on the git plugin for work_in_progress()

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}  "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Customized git status
git_custom_status() {
  local cb=$(git_current_branch)
  if [ -n "$cb" ]; then
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX%{$fg_bold[yellow]%}$(work_in_progress)%{$reset_color%}%{$fg[cyan]%}$(git_current_branch)$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Relies on patched powerline font and emoji plugin
PROMPT='%{$FG[013]%}$(virtualenv_prompt_info)%{$FG[033]%}[%2~]$(git_custom_status)%(?.%{$fg[green]%}.%{$fg[red]%}) %B$%b '

