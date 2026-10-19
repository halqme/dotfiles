# Completion definitions must load before compinit; fzf-tab follows compinit.
typeset -ga _zsh_completion_watch_paths=()

zsh_completion_watch() {
  [[ -n $1 && -r $1 ]] && _zsh_completion_watch_paths+=("$1")
}

zsh_completion_cache_is_stale() {
  local cache_file=$1 watch_path
  [[ ! -r $cache_file ]] && return 0

  for watch_path in "${_zsh_completion_watch_paths[@]}"; do
    [[ $watch_path -nt $cache_file ]] && return 0
  done
  return 1
}

_zsh_load_completion() {
  zsh_completion_dir=''
  zsh_fzf_tab_plugin=''
  zsh_plugin_path zsh-completions . && zsh_completion_dir=$REPLY
  zsh_plugin_path fzf-tab fzf-tab.zsh && zsh_fzf_tab_plugin=$REPLY
  zsh_completion_watch "$zsh_completion_dir"
  zsh_completion_watch "$zsh_fzf_tab_plugin"
  [[ -n $zsh_completion_dir ]] && fpath=("$zsh_completion_dir" $fpath)

  autoload -Uz compinit
  zsh_cache_path zcompdump
  zsh_completion_dump=$REPLY
  if mkdir -p -- "$ZSH_CACHE_DIR" 2>/dev/null; then
    if zsh_completion_cache_is_stale "$zsh_completion_dump"; then
      compinit -d "$zsh_completion_dump"
    else
      compinit -C -d "$zsh_completion_dump"
    fi
  else
    compinit
  fi

  zsh_source_if_exists "$zsh_fzf_tab_plugin"
  unset zsh_completion_dir zsh_fzf_tab_plugin zsh_completion_dump
}

if [[ -o interactive ]]; then
  zsh_defer_on_first_input _zsh_load_completion
fi

return 0
