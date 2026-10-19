# Runtime helpers. This file is loaded before every configuration phase.
typeset -g ZSH_CONFIG_ROOT=${ZSH_CONFIG_ROOT:-${${(%):-%N}:A:h:h}}
typeset -g ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh

zsh_source_if_exists() {
  [[ -r $1 ]] || return 1
  source "$1"
}

zsh_homebrew_path() {
  local formula=$1 relative_path=$2 prefix
  local -a prefixes

  prefixes=("${HOMEBREW_PREFIX-}" /opt/homebrew /usr/local)
  typeset -U prefixes
  for prefix in "${prefixes[@]}"; do
    [[ -n $prefix ]] || continue
    [[ -r "$prefix/opt/$formula/$relative_path" ]] && {
      REPLY="$prefix/opt/$formula/$relative_path"
      return 0
    }
    [[ -r "$prefix/share/$formula/$relative_path" ]] && {
      REPLY="$prefix/share/$formula/$relative_path"
      return 0
    }
  done
  return 1
}

zsh_source_homebrew() {
  zsh_homebrew_path "$1" "$2" || return 1
  zsh_source_if_exists "$REPLY"
}

zsh_plugin_path() {
  zsh_homebrew_path "$1" "$2" && return 0
  REPLY="$HOME/.local/share/zsh/$1/$2"
  [[ -r $REPLY ]]
}

zsh_source_plugin() {
  zsh_plugin_path "$1" "$2" || return 1
  zsh_source_if_exists "$REPLY"
}

zsh_cache_path() {
  REPLY="$ZSH_CACHE_DIR/$1"
}

zsh_source_command_cached() {
  local name=$1 watch_path=$2 cache_file temp_file
  shift 2

  zsh_cache_path "$name"
  cache_file=$REPLY
  if [[ ! -r $cache_file || $watch_path -nt $cache_file ]] && mkdir -p -- "$ZSH_CACHE_DIR" 2>/dev/null; then
    temp_file="$cache_file.$$"
    if "$@" >| "$temp_file"; then
      mv -f -- "$temp_file" "$cache_file"
    else
      rm -f -- "$temp_file"
    fi
  fi

  [[ -r $cache_file ]] && source "$cache_file" || source <("$@")
}

zsh_load_required_phase() {
  local file
  for file in "$@"; do
    zsh_source_if_exists "$ZSH_CONFIG_ROOT/$file" || {
      print -u2 -- "zsh: required phase is missing or failed: $ZSH_CONFIG_ROOT/$file"
      return 1
    }
  done
}

zsh_load_optional_phase() {
  local file
  for file in "$@"; do
    zsh_source_if_exists "$ZSH_CONFIG_ROOT/$file"
  done
  return 0
}
