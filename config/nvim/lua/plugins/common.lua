return {
  {
    'vim-denops/denops.vim',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      vim.g['denops#deno'] = '/opt/homebrew/bin/deno'
    end,
  },
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
    event = 'VeryLazy',
  },
  {
    'MunifTanjim/nui.nvim',
    lazy = true,
    event = 'VeryLazy',
  }
}
