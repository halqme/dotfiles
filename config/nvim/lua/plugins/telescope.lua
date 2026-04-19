return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-telescope/telescope-fzf-native.nvim' },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          prompt_prefix = '🔍 ',
          selection_caret = '▶ ',
          path_display = { 'truncate' },
          sorting_strategy = 'ascending',
          layout_config = {
            horizontal = { prompt_position = 'top', preview_width = 0.55 },
            width = 0.87,
            height = 0.80,
          },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })
      pcall(telescope.load_extension, 'fzf')
    end,
  },
}
