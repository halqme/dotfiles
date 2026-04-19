return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    cmdline = {
      enabled = true,
      view = 'cmdline_popup',
      format = {
        cmdline = { icon = '>' },
        search_down = { icon = '🔍⌄' },
        search_up = { icon = '🔍⌃' },
      },
    },
    popupmenu = { enabled = true, backend = 'nui' },
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    messages = {
      enabled = true,            -- enables the Noice messages UI
      view = 'mini',             -- default view for messages
      view_error = 'notify',     -- view for errors
      view_warn = 'notify',      -- view for warnings
      view_history = 'messages', -- view for :messages
      view_search = 'mini',      -- view for search count messages. Set to `false` to disable
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
    views = {
      cmdline_popup = {
        border = { style = 'rounded' },
        win_options = { winblend = 0 },
      },
      popupmenu = {
        border = { style = 'rounded' },
        win_options = { winblend = 0 },
      },
      mini = {
        win_options = { winblend = 0 },
      },
      notify = {
        border = { style = 'rounded' },
        win_options = { winblend = 0 },
      }
    },
  },
  config = function(_, opts)
    require('noice').setup(opts)
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  end,
}
