if [[ -o interactive ]]; then
  zsh_source_plugin powerlevel10k powerlevel10k.zsh-theme
  zsh_source_if_exists "$ZSH_CONFIG_ROOT/.p10k.zsh"
fi
