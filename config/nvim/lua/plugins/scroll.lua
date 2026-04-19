return {
  "karb94/neoscroll.nvim",
  lazy = true,
  keys = {
    { '<C-u>', 'n' },
    { '<C-d>', 'n' },
  },
  config = function()
    require('neoscroll').setup({})
  end,
}
