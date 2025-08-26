return {
  {
    "nvim-treesitter",
    after = function()
      require("nvim-treesitter.configs").setup({
        modules = {},
        sync_install = false,
        ignore_install = {},
        ensure_installed = {},
        auto_install = false,
        indent = {
          enable = true,
        },
        context_commentstring = {
          enable = true,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
  {
    "nvim-treesitter-context",
    event = "DeferredUIEnter",
    before = function()
      require("lz.n").trigger_load("nvim-treesitter")
    end,
    after = function()
      require("treesitter-context").setup({
        enable = true,
        multiwindow = false,
        max_lines = 8,
        min_window_height = 16,
        line_numbers = true,
        mode = "cursor",
      })
    end,
  },
  {
    "nvim-treesitter-textobjects",
    event = "DeferredUIEnter",
    before = function()
      require("lz.n").trigger_load("nvim-treesitter")
    end,
    after = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {},
      })
    end,
    binds = {},
  },
}
