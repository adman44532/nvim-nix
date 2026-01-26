return {
  "snacks.nvim",
  priority = 1000,
  lazy = false,
  load = function()
    vim.cmd([[packadd snacks.nvim]])
  end,
  before = function()
    require("lz.n").trigger_load("mini.icons")
  end,
  after = function()
    local snacks = require("snacks")

    snacks.setup({
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = {
        enabled = false,
      },
      scope = {
        enabled = true,
        only_current = true,
      },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {},
      },
    })

    _G.dd = function(...)
      snacks.debug.inspect(...)
    end

    _G.bt = function()
      snacks.debug.backtrace()
    end

    if vim.fn.has("nvim-0.11") == 1 then
      vim._print = function(_, ...)
        dd(...)
      end
    else
      vim.print = _G.dd
    end

    local toggle_spell = snacks.toggle.option("spell", { name = "Spelling" })
    local toggle_wrap = snacks.toggle.option("wrap", { name = "Wrap" })
    local toggle_relativenumber =
      snacks.toggle.option("relativenumber", { name = "Relative Number" })
    local toggle_diagnostics = snacks.toggle.diagnostics()
    local toggle_line_number = snacks.toggle.line_number()
    local toggle_conceallevel = snacks.toggle.option(
      "conceallevel",
      { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }
    )
    local toggle_treesitter = snacks.toggle.treesitter()
    local toggle_background =
      snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" })
    local toggle_inlay_hints = snacks.toggle.inlay_hints()
    local toggle_indent = snacks.toggle.indent()
    local toggle_dim = snacks.toggle.dim()

    _G.SNACKS_TOGGLES = {
      spell = toggle_spell,
      wrap = toggle_wrap,
      relativenumber = toggle_relativenumber,
      diagnostics = toggle_diagnostics,
      line_number = toggle_line_number,
      conceallevel = toggle_conceallevel,
      treesitter = toggle_treesitter,
      background = toggle_background,
      inlay_hints = toggle_inlay_hints,
      indent = toggle_indent,
      dim = toggle_dim,
    }
  end,
  binds = {
    {
      "<leader><leader>",
      function()
        require("snacks").picker.buffers()
      end,
      desc = "Buffers",
    },

    -- Find
    {
      "<leader>sf",
      function()
        require("snacks").picker.files()
      end,
      desc = "Search Files",
    },
    {
      "<leader>sG",
      function()
        require("snacks").picker.git_files()
      end,
      desc = "Search Git Files",
    },
    {
      "<leader>sp",
      function()
        require("snacks").picker.projects()
      end,
      desc = "Search Projects",
    },
    {
      "<leader>sR",
      function()
        require("snacks").picker.recent()
      end,
      desc = "Search Recent",
    },

    -- Grep
    {
      "<leader>sb",
      function()
        require("snacks").picker.lines()
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader>sB",
      function()
        require("snacks").picker.grep_buffers()
      end,
      desc = "Grep Open Buffers",
    },
    {
      "<leader>sg",
      function()
        require("snacks").picker.grep()
      end,
      desc = "Search Grep",
    },
    {
      "<leader>sw",
      function()
        require("snacks").picker.grep_word()
      end,
      desc = "Search Word",
    },
    {
      "<leader>sn",
      function()
        require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Search Neovim files",
    },

    -- Search
    {
      '<leader>s"',
      function()
        require("snacks").picker.registers()
      end,
      desc = "Registers",
    },
    {
      "<leader>sc",
      function()
        require("snacks").picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>sC",
      function()
        require("snacks").picker.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>sd",
      function()
        if vim.fn.executable("fd") == 0 then
          vim.notify("'fd' command not found", vim.log.levels.ERROR)
          return
        end

        require("snacks").picker.pick({
          title = "Search Directories (Open with oil.nvim)",
          finder = function(opts, ctx)
            return require("snacks.picker.source.proc").proc(
              ctx:opts({
                cmd = "fd",
                args = { "--type", "d", "--color", "never", "-E", ".git" },
                notify = false,
                transform = function(item)
                  item.file = item.text
                  item.dir = true
                end,
              }),
              ctx
            )
          end,
          format = "file",
          confirm = function(picker, item)
            picker:close()
            require("oil").open(item.file)
          end,
        })
      end,
      desc = "Search Directories (oil.nvim)",
    },
    {
      "<leader>sD",
      function()
        require("snacks").picker.diagnostics()
      end,
      desc = "Search Diagnostics",
    },
    {
      "<leader>sh",
      function()
        require("snacks").picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>si",
      function()
        require("snacks").picker.icons()
      end,
      desc = "Icons",
    },
    {
      "<leader>sk",
      function()
        require("snacks").picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sM",
      function()
        require("snacks").picker.man()
      end,
      desc = "Man Pages",
    },
    {
      "<leader>su",
      function()
        require("snacks").picker.undo()
      end,
      desc = "Undo History",
    },

    -- LSP
    {
      "gd",
      function()
        require("snacks").picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "gD",
      function()
        require("snacks").picker.lsp_declarations()
      end,
      desc = "Goto Declaration",
    },
    {
      "gr",
      function()
        require("snacks").picker.lsp_references()
      end,
      nowait = true,
      desc = "References",
    },
    {
      "gI",
      function()
        require("snacks").picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
    {
      "gy",
      function()
        require("snacks").picker.lsp_type_definitions()
      end,
      desc = "Goto T[y]pe Definition",
    },
    {
      "gai",
      function()
        require("snacks").picker.lsp_incoming_calls()
      end,
      desc = "C[a]lls Incoming",
    },
    {
      "gao",
      function()
        require("snacks").picker.lsp_outgoing_calls()
      end,
      desc = "C[a]lls Outgoing",
    },
    {
      "<leader>ss",
      function()
        require("snacks").picker.lsp_symbols()
      end,
      desc = "LSP Symbols",
    },
    {
      "<leader>sS",
      function()
        require("snacks").picker.lsp_workspace_symbols()
      end,
      desc = "LSP Workspace Symbols",
    },

    -- Other
    {
      "<leader>.",
      function()
        require("snacks").scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        require("snacks").scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
    {
      "<leader>n",
      function()
        require("snacks").notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>cR",
      function()
        require("snacks").rename.rename_file()
      end,
      desc = "Rename File",
    },
    {
      "<leader>gB",
      function()
        require("snacks").gitbrowse()
      end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },
    {
      "<leader>gg",
      function()
        require("snacks").lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>un",
      function()
        require("snacks").notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },

    {
      "]]",
      function()
        require("snacks").words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        require("snacks").words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },

    -- Toggles
    {
      "<leader>us",
      function()
        _G.SNACKS_TOGGLES.spell:toggle()
      end,
      desc = "Toggle Spelling",
    },
    {
      "<leader>uw",
      function()
        _G.SNACKS_TOGGLES.wrap:toggle()
      end,
      desc = "Toggle Wrap",
    },
    {
      "<leader>uL",
      function()
        _G.SNACKS_TOGGLES.relativenumber:toggle()
      end,
      desc = "Toggle Relative Number",
    },
    {
      "<leader>ud",
      function()
        _G.SNACKS_TOGGLES.diagnostics:toggle()
      end,
      desc = "Toggle Diagnostics",
    },
    {
      "<leader>ul",
      function()
        _G.SNACKS_TOGGLES.line_number:toggle()
      end,
      desc = "Toggle Line Number",
    },
    {
      "<leader>uc",
      function()
        _G.SNACKS_TOGGLES.conceallevel:toggle()
      end,
      desc = "Toggle Conceallevel",
    },
    {
      "<leader>uT",
      function()
        _G.SNACKS_TOGGLES.treesitter:toggle()
      end,
      desc = "Toggle Treesitter",
    },
    {
      "<leader>ub",
      function()
        _G.SNACKS_TOGGLES.background:toggle()
      end,
      desc = "Toggle Dark Background",
    },
    {
      "<leader>uh",
      function()
        _G.SNACKS_TOGGLES.inlay_hints:toggle()
      end,
      desc = "Toggle Inlay Hints",
    },
    {
      "<leader>ug",
      function()
        _G.SNACKS_TOGGLES.indent:toggle()
      end,
      desc = "Toggle Indent",
    },
    {
      "<leader>uD",
      function()
        _G.SNACKS_TOGGLES.dim:toggle()
      end,
      desc = "Toggle Dim",
    },
  },
}
