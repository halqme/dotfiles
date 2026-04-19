-- Completion settings optimized for blink.cmp
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Fallback omnifunc for non-LSP files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text' },
  callback = function()
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
  end,
})
