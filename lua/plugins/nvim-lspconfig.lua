return {
  "nvim-lspconfig",
  lazy = false,
  before = function()
    require("lz.n").trigger_load("blink.cmp")
  end,
  after = function()
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
      vtsls = {
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
            inlayHints = {
              bindingModeHints = { enable = true },
              chainingHints = { enable = true },
              closingBraceHints = { enable = true },
              closureReturnTypeHints = { enable = "always" },
              lifetimeElisionHints = { enable = "always" },
              parameterHints = { enable = true },
              typeHints = { enable = true },
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
            },
            procMacro = {
              enable = true,
            },
          },
        },
      },
      emmet_language_server = {
        filetypes = {
          "html",
          "css",
          "scss",
          "less",
          "javascriptreact",
          "typescriptreact",
          "vue",
          "svelte",
          "astro",
        },
      },
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
}
