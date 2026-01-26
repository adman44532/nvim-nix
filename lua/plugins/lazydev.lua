return {
  "lazydev.nvim",
  ft = "lua",
  after = function()
    require("lazydev").setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    })
  end,
}
