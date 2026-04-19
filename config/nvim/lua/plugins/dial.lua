return {
  'monaqa/dial.nvim',
  event = 'VeryLazy',
  keys = {
    { '<C-a>', ':DialIncrement<CR>' },
    { '<C-x>', ':DialDecrement<CR>' },
  }
}
