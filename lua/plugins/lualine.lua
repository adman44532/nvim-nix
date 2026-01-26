return {
  "lualine.nvim",
  before = function()
    require("lz.n").trigger_load("mini.icons")
  end,
  after = function()
    require("lualine").setup()
  end,
}
