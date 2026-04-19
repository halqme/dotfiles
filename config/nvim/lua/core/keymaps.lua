vim.g.mapleader = ' '
local map = vim.keymap.set

-- LSP (simplified)
map('n', 'gh', vim.lsp.buf.hover, { desc = 'Hover' })
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Definition' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
map('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
map('n', 'g]', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
map('n', 'g[', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })

-- Buffer
map('n', '<leader>[', ':bprev<CR>', { desc = 'Prev Buffer' })
map('n', '<leader>]', ':bnext<CR>', { desc = 'Next Buffer' })
map('n', '<leader>ww', ':bd<CR>', { desc = 'Close Buffer' })

-- Quick actions
map({ 'n', 'x' }, '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', { desc = 'Format' })
map('n', '<leader>ss', '<cmd>split<CR>', { desc = 'Split Horizontal' })
map('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = 'Split Vertical' })

-- Window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Telescope
map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find Files' })
map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = 'Live Grep' })
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Buffers' })
map('n', '<leader>fd', '<cmd>Telescope diagnostics<CR>', { desc = 'Diagnostics' })
