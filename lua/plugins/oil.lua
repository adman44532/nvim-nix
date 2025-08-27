return {
  "oil",
  priority = 1000,
  lazy = false,
  load = function()
    vim.cmd([[packadd oil.nvim]])
  end,
  before = function()
    require("lz.n").trigger_load('nvim-web-devicons')
  end,
  after = function()
    require("oil").setup()
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end
}
