if [[ -o interactive ]] && (( $+commands[fzf] )); then
  zsh_source_command_cached fzf.zsh "${commands[fzf]}" fzf --zsh
fi

if (( $+commands[zoxide] )); then
  zsh_source_command_cached zoxide.zsh "${commands[zoxide]}" zoxide init zsh
fi

if (( $+commands[yazi] )); then
  y() {
    local tmp cwd
    tmp="$(mktemp -t 'yazi-cwd.XXXXX')"
    command yazi "$@" --cwd-file="$tmp"
    if cwd="$(<"$tmp")" && [[ -n $cwd && $cwd != $PWD ]]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi

if (( $+commands[lazygit] )); then
  lg() {
    export LAZYGIT_NEW_DIR_FILE="$HOME/.cache/lazygit/newdir"
    command lazygit "$@"
    if [[ -f $LAZYGIT_NEW_DIR_FILE ]]; then
      cd "$(<"$LAZYGIT_NEW_DIR_FILE")"
      rm -f -- "$LAZYGIT_NEW_DIR_FILE"
    fi
  }
fi

_zsh_load_bun_completion_for_project() {
  [[ -n ${_zsh_bun_completion_loaded-} ]] && return

  local directory=$PWD
  while [[ $directory != / ]]; do
    if [[ -f $directory/package.json || -f $directory/bunfig.toml || -f $directory/bun.lock || -f $directory/bun.lockb ]]; then
      zsh_source_if_exists "$HOME/.bun/_bun" || return
      typeset -g _zsh_bun_completion_loaded=1
      add-zsh-hook -d chpwd _zsh_load_bun_completion_for_project
      return
    fi
    directory=${directory:h}
  done
}

if [[ -o interactive ]]; then
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd _zsh_load_bun_completion_for_project
  _zsh_load_bun_completion_for_project
fi

zsh_source_if_exists "$HOME/.vite-plus/env"

if (( $+commands[direnv] )); then
  zsh_source_command_cached direnv.zsh "${commands[direnv]}" direnv hook zsh
fi

return 0
