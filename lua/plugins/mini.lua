return {
  {
    "mini.ai",
    lazy = false,
    after = function()
      require("mini.ai").setup({ n_lines = 500 })
    end,
  },
  {
    "mini.surround",
    lazy = false,
    after = function()
      require("mini.surround").setup()
    end,
  },
  {
    "mini.comment",
    lazy = false,
    after = function()
      require("mini.comment").setup()
    end,
  },
  {
    "mini.pairs",
    lazy = false,
    after = function()
      require("mini.pairs").setup()
    end,
  },
  {
    "mini.indentscope",
    lazy = false,
    after = function()
      require("mini.indentscope").setup()
    end,
  },
  {
    "mini.statusline",
    lazy = false,
    after = function()
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end,
  },
}
