return {
  { "none-ls.nvim" },
  {
    "nvim-lspconfig",
    lazy = false,
    before = function()
      require("lz.n").trigger_load("none-ls.nvim")
      require("lz.n").trigger_load("blink.cmp")
    end,
    binds = {
      {
        {
          "grd",
          function()
            vim.lsp.buf.definition()
          end,
          desc = "Goto Definition",
        },
        {
          "grD",
          function()
            vim.lsp.buf.declaration()
          end,
          desc = "Goto Declaration",
        },
        {
          "grr",
          function()
            vim.lsp.buf.references()
          end,
          desc = "Goto References",
        },
        {
          "gri",
          function()
            vim.lsp.buf.implementation()
          end,
          desc = "Goto Implementations",
        },
        {
          "grt",
          function()
            vim.lsp.buf.type_definition()
          end,
          desc = "Goto Implementations",
        },
        {
          "gra",
          function()
            vim.lsb.buf.code_action()
          end,
          desc = "Actions",
        },
        {
          "grn",
          function()
            vim.lsp.buf.rename()
          end,
          desc = "Rename",
        },
      },
    },
    after = function()
      -- Setup NoneLS, basically a default LS incase another one isn't there
      local nonels = require("null-ls")

      local code_actions = nonels.builtins.code_actions
      local diagnostics = nonels.builtins.diagnostics
      local formatting = nonels.builtins.formatting

      local ls_sources = {
        formatting.sylua,
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

      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local servers = {
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarrc.jsonc") then
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
        nil_ls = {
          cmd = { "nil" },
          settings = {
            ["nil"] = {
              nix = {
                binary = "nix",
                maxMemoryMB = nil,
                flake = {
                  autoEvalInputs = false, -- Fullscreen errors? no.
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
        ts_ls = {},
        pyright = {},
        texlab = {},
        yamlls = {},
        bashls = {},
        fish_lsp = {},
        marksman = {},
        jsonls = {},
      }

      for server_name, server_config in pairs(servers) do
        server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
        lspconfig[server_name].setup(server_config)
      end
    end
  }
}
