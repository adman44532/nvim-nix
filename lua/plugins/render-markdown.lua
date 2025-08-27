return {
  'render-markdown.nvim',
  before = function ()
    require('lz.n').trigger_load('nvim-treesitter')
    require('lz.n').trigger_load('nvim-web-devicons')
  end,
  after = function ()
    require('render-markdown').setup({})
  end
}
