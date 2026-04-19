local opt = vim.opt

-- line number
opt.number = true
opt.relativenumber = true

-- indent
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4

-- wrap
opt.wrap = false

-- search
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes'
opt.showmode = false
opt.showcmd = false
opt.autoread = true
opt.cmdheight = 0
opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 10

opt.list = true
opt.listchars = { tab = '▸ ', trail = '⋅', nbsp = '␣', extends = '❯', precedes = '❮' }

opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300

-- clipboard
opt.clipboard:append('unnamedplus,unnamed')

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append('=')
opt.laststatus = 3

-- Better diagnostics
vim.diagnostic.config({
  virtual_text = { prefix = '●' },
  float = { border = 'rounded' },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
