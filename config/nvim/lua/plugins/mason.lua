return {
  {
    'mason-org/mason.nvim',
    build = ':MasonUpdate',
    cmd = 'Mason',
    config = true,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'mason-org/mason.nvim', 'neovim/nvim-lspconfig' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mason-lspconfig').setup({ automatic_installation = true })
    end,
  },
}
