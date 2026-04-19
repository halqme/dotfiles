return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 500,
    win = {
      border = 'rounded',
      wo = {
        winblend = 0,
      },
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
    wk.add({
      { '<leader>f', group = 'Find' },
      { '<leader>c', group = 'Code' },
      { '<leader>s', group = 'Split' },
      { '<leader>w', group = 'Window' },
      { 'g', group = 'Go to' },
    })
  end,
}
