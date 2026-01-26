return {
  "nvim-treesitter",
  priority = 1000,
  lazy = false,
  load = function()
    vim.cmd([[packadd nvim-treesitter]])
  end,
  after = function()
    -- TODO: Implement
  end,
}
