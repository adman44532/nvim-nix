return {
  "catppuccin",
  priority = 1000,
  lazy = false,
  load = function()
    vim.cmd([[packadd catppuccin-nvim]])
  end,
  after = function()
    require("catppuccin").setup({ flavour = "mocha" })
    vim.cmd.colorscheme("catppuccin")
  end
}
