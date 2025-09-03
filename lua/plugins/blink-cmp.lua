return {
  {
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
  },
  {
    "friendly-snippets",
  },
  {
    "luasnip",
    before = function()
      require("lz.n").trigger_load("friendly-snippets")
    end,
    after = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip").setup({
        history = true,
        delete_check_events = "TextChanged",
        keys = function()
          return {}
        end,
      })
    end,
  },
  {
    "blink-cmp-avante",
  },
  {
    "blink.cmp",
    event = "DeferredUIEnter",
    before = function()
      require("lz.n").trigger_load("blink-cmp-avante")
      require("lz.n").trigger_load("lazydev.nvim")
    end,
    after = function()
      require("blink-cmp").setup({
        signature = {
          enabled = true,
          window = {
            border = "single",
          },
        },
        completion = {
          ghost_text = {
            enabled = false,
          },
          menu = {},
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 300,
            window = {
              border = "single",
            },
          },
        },
        sources = {
          default = {
            "avante",
            "lazydev",
            "lsp",
            "path",
            "snippets",
            "buffer",
          },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100,
            },
            avante = {
              module = "blink-cmp-avante",
              name = "Avante",
              opts = {
                -- options for blink-cmp-avante
              },
            },
          },
        },
      })
    end,
    binds = {
      {
        "<C-space>",
        function()
          require("blink-cmp").show()
        end,
      },
    },
  },
}
