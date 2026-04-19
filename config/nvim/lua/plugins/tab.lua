return {
  'akinsho/bufferline.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('bufferline').setup({})
  end,
}
