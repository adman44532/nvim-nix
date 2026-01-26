return {
  {
    "blink.cmp",
    event = "DeferredUIEnter",
    before = function()
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
          menu = {
            draw = {
              columns = {
                { "label", "label_description", gap = 1 },
                { "kind_icon", "kind", gap = 1 },
                { "source_name" },
              },
              components = {
                source_name = {
                  text = function(ctx)
                    return "[" .. ctx.source_name .. "]"
                  end,
                  highlight = "BlinkCmpSource",
                },
              },
            },
          },
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
            "lazydev",
            "lsp",
            "path",
            "snippets",
          },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100,
            },
            lsp = {
              name = "LSP",
              module = "blink.cmp.sources.lsp",
              fallbacks = { "buffer" },
            },
            snippets = {
              name = "Snippets",
              module = "blink.cmp.sources.snippets",
              opts = { use_label_description = true },
            },
            path = {
              name = "Path",
              module = "blink.cmp.sources.path",
              score_offset = 3,
            },
            buffer = {
              name = "Buffer",
              module = "blink.cmp.sources.buffer",
              score_offset = -3,
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
