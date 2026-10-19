# Widget-wrapping plugins are deferred together and retain this order.
_zsh_load_input_widgets() {
  zsh_source_plugin zsh-autosuggestions zsh-autosuggestions.zsh
  zsh_source_plugin zsh-fast-syntax-highlighting fast-syntax-highlighting.plugin.zsh
}

[[ -o interactive && -o zle ]] && zsh_defer_on_first_input _zsh_load_input_widgets

return 0
