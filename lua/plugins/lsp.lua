return {
  { "none-ls.nvim", priority = 1000 },
  {
    "tiny-inline-diagnostic.nvim",
    priority = 1000,
    after = function()
      require("tiny-inline-diagnostic").setup({
        preset = "classic",
      })
      vim.diagnostic.config({ virtual_text = false })
    end,
  },
  {
    "typescript-tools.nvim",
    ft = { "typescript", "typescriptreact" },
    before = function()
      require("lz.n").trigger_load("nvim-lspconfig")
    end,
    after = function()
      -- typescript-tools still uses its own setup method
      -- It's compatible with the new LSP system
      require("typescript-tools").setup({})
    end,
  },
  {
    "nvim-lspconfig",
    lazy = false,
    before = function()
      require("lz.n").trigger_load("blink.cmp")
      require("lz.n").trigger_load("none-ls.nvim")
      require("lz.n").trigger_load("tiny-inline-diagnostic")
    end,
    after = function()
      -- Setup NoneLS
      local nonels = require("null-ls")
      local code_actions = nonels.builtins.code_actions
      local diagnostics = nonels.builtins.diagnostics
      local formatting = nonels.builtins.formatting

      local ls_sources = {
        formatting.stylua,
        formatting.alejandra,
        diagnostics.statix,
        code_actions.statix,
        diagnostics.deadnix,
      }

      nonels.setup({
        diagnostics_format = "[#{m}] #{s} (#{c})",
        debounce = 250,
        default_timeout = 5000,
        sources = ls_sources,
      })

      -- Get capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Configure global LSP settings (applies to all servers)
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Server-specific configurations
      local servers = {
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if
                vim.uv.fs_stat(path .. "/.luarc.json")
                or vim.uv.fs_stat(path .. "/.luarrc.jsonc")
              then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              format = {
                enable = true,
              },
              runtime = {
                version = "LuaJIT",
              },
              telemetry = {
                enable = false,
              },
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                disable = {
                  "missing-fields",
                },
              },
            })
          end,
          settings = {
            Lua = {},
          },
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  "clsx%(([^)]*)%)",
                  "cva%(([^)]*)%)",
                },
              },
            },
          },
        },
        nil_ls = {
          cmd = { "nil" },
          settings = {
            ["nil"] = {
              nix = {
                binary = "nix",
                maxMemoryMB = nil,
                flake = {
                  autoEvalInputs = false,
                  autoArchive = false,
                  nixpkgsInputName = nil,
                },
              },
              formatting = {
                command = { "alejandra" },
              },
            },
          },
        },
        eslint = {},
        ty = {},
        ruff = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        texlab = {},
        yamlls = {},
        bashls = {},
        fish_lsp = {},
        marksman = {},
        jsonls = {},
      }

      -- Register and enable each server
      for server_name, server_config in pairs(servers) do
        -- Merge capabilities with server-specific config
        server_config.capabilities =
          vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})

        -- Register the server configuration
        vim.lsp.config(server_name, server_config)

        -- Enable the server
        vim.lsp.enable(server_name)
      end
    end,
  },
}
