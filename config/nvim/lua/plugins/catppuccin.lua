return {
  'catppuccin/nvim',
  name = 'catppuccin',
  event = 'VimEnter',
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = 'macchiato',
      transparent_background = true,
      show_end_of_buffer = false,
      term_colors = true,
      no_italic = false,
      no_bold = false,
      no_underline = false,
      color_overrides = {},
      default_integrations = true,
      integrations = {
        nvimtree = true,
        treesitter = true,
        noice = true,
        telescope = {
          enable = true,
          style = 'nvchad'
        }
      },
      custom_highlights = function(colors)
        return {
          Comment = { fg = colors.surface },
          LineNr = { fg = colors.overlay2 },
        }
      end
    })

    vim.cmd.colorscheme('catppuccin')
    
    -- Set winblend for floating windows
    vim.o.winblend = 0
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'lazy', 'mason' },
      callback = function()
        vim.wo.winblend = 0
      end,
    })
  end,
}
