return {
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      -- Better around/inside textobjects
      require('mini.ai').setup()

      -- Highlight word under cursor
      require('mini.cursorword').setup()

      -- Visualize and work with indent scope
      require('mini.indentscope').setup({
        symbol = '│',
        options = { try_as_border = true },
      })

      -- Fast navigation with f/F/t/T
      require('mini.jump').setup()

      -- Extend and create a/i textobjects
      require('mini.bracketed').setup()
    end,
  },
}
