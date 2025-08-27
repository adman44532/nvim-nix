return {
  'tailwind-tools.nvim',
  ft = {"html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact"},
  before = function ()
    require('lz.n').trigger_load("nvim-treesitter")
    require('lz.n').trigger_load("telescope.nvim")
    require('lz.n').trigger_load("nvim-lspconfig")
  end
}
