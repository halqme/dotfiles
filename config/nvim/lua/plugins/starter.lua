return {
  {
    'echasnovski/mini.starter',
    version = false,
    event = 'VimEnter',
    config = function()
      local starter = require('mini.starter')
      starter.setup({
        autoopen = true,

        evaluate_single = true,

        -- 表示するアイテム
        items = {
          starter.sections.builtin_actions(),
          starter.sections.recent_files(10, false),           -- 最近開いたファイルを10件表示
          starter.sections.recent_files(5, true),             -- セッションを保存している場合、最近のセッションを表示
        },
      })
    end,
  }
}
