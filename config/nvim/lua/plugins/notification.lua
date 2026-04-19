return {
  {
    'rcarriga/nvim-notify',
    event = "VeryLazy",
    config = function()
      require("notify").setup({
        render = "compact",
        stages = "slide",
        timeout = 1500,
        background_colour = "#000000",
        text_colour = "#ffffff",
        icons = {
          ERROR = " ",
          WARN  = " ",
          INFO  = " ",
          DEBUG = " ",
          TRACE = "✎ ",
        },
      })
    end,
  }
}
