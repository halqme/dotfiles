return {
  {
    'stevearc/oil.nvim',
    lazy = true,
    keys = {
      { '<Leader>o', '<CMD>Oil --float<CR>' }
    },
    config = function()
      require('oil').setup({
        default_file_explorer = true,
        columns = {
          'icon',
        },
        buf_options = {
          buflisted = false,
          bufhidden = 'hide',
        },
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = true,
          list = true,
          conceallevel = 3,
          concealcursor = 'nvic',
        },
        delete_to_trash = true,
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
          enabled = true,
          autosave_changes = true,
        },
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-s>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
          ['<C-h>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
          ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = 'actions.close',
          ['<C-l>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory', mode = 'n' },
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
          ['g\\'] = 'actions.toggle_trash',
        },
        view_options = {
          -- Show files and directories that start with '.'
          show_hidden = true,
          -- This function defines what is considered a 'hidden' file
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, '.')
          end,
          -- This function defines what will never be shown, even when `show_hidden` is set
          is_always_hidden = function(name, bufnr)
            return vim.startswith(name, '.DS_Store')
          end,
          -- Sort file names in a more intuitive order for humans. Is less performant,
          -- so you may want to set to false if you work with large directories.
          natural_order = true,
          -- Sort file and directory names case insensitive
          case_insensitive = false,
          sort = {
            -- sort order can be 'asc' or 'desc'
            -- see :help oil-columns to see which columns are sortable
            { 'type', 'asc' },
            { 'name', 'asc' },
          },
        },
      })
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    lazy = true,
    keys = {
      { '<Leader>e', '<CMD>Neotree toggle<CR>' }
    },
  }
}
