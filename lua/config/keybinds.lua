local wk = require("which-key")
wk.setup({
  preset = "classic",
})

wk.add({
  -- Clear search highlights
  { "<Esc>", "<cmd>nohlsearch<CR>", desc = "Clear search highlights", icon = "🔍" },

  -- Diagnostics group
  { "<leader>d", vim.diagnostic.open_float, desc = "Show [d]iagnostic popup", icon = "⚠️" },
  {
    "<leader>q",
    vim.diagnostic.setloclist,
    desc = "Open diagnostic [Q]uickfix list",
    icon = "📋",
  },
  {
    "[d",
    function()
      vim.diagnostic.jump({ count = -1, float = true })
    end,
    desc = "Go to previous [d]iagnostic",
    icon = "⬆️",
  },
  {
    "]d",
    function()
      vim.diagnostic.jump({ count = 1, float = true })
    end,
    desc = "Go to next [d]iagnostic",
    icon = "⬇️",
  },

  -- File management
  { "-", "<CMD>Oil<CR>", desc = "Open parent directory", icon = "📁" },

  -- Line/block movement in normal mode
  { "<C-j>", ":m .+1<CR>==", desc = "Move line down", icon = "↓", mode = "n" },
  { "<C-k>", ":m .-2<CR>==", desc = "Move line up", icon = "↑", mode = "n" },

  -- Line/block movement in visual mode
  { "<C-j>", ":m '>+1<CR>gv=gv", desc = "Move block down", icon = "↓", mode = "x" },
  { "<C-k>", ":m '<-2<CR>gv=gv", desc = "Move block up", icon = "↑", mode = "x" },

  -- Terminal mode
  { "<Esc><Esc>", "<C-\\><C-n>", desc = "Exit terminal mode", icon = "🖥️", mode = "t" },

  -- Window navigation (note: these conflict with line movement above)
  -- Commenting out the conflicting ones as the line movement seems more useful
  { "<C-h>", "<C-w><C-h>", desc = "Move focus to left window", icon = "⬅️" },
  { "<C-l>", "<C-w><C-l>", desc = "Move focus to right window", icon = "➡️" },
  -- { '<C-j>', '<C-w><C-j>', desc = 'Move focus to lower window', icon = '⬇️' },
  -- { '<C-k>', '<C-w><C-k>', desc = 'Move focus to upper window', icon = '⬆️' },

  -- Test file management
  { "<leader>t", group = "[T]est & [T]oggle", icon = "🧪" },
  {
    "<leader>tt",
    function()
      local path = vim.api.nvim_buf_get_name(0)

      -- Check if current file is a test file
      if path:match("%.e2e%.test%.ts$") or path:match("%.e2e%.test%.js$") then
        local src = path:gsub("%.e2e%.test%.ts$", ".ts"):gsub("%.e2e%.test%.js$", ".js")
        vim.cmd("edit " .. src)
      elseif path:match("%.integration%.test%.ts$") or path:match("%.integration%.test%.js$") then
        local src =
          path:gsub("%.integration%.test%.ts$", ".ts"):gsub("%.integration%.test%.js$", ".js")
        vim.cmd("edit " .. src)
      elseif path:match("%.test%.ts$") or path:match("%.test%.js$") then
        local src = path:gsub("%.test%.ts$", ".ts"):gsub("%.test%.js$", ".js")
        vim.cmd("edit " .. src)
      elseif path:match("%.spec%.ts$") or path:match("%.spec%.js$") then
        local src = path:gsub("%.spec%.ts$", ".ts"):gsub("%.spec%.js$", ".js")
        vim.cmd("edit " .. src)
      elseif path:match("%.ts$") or path:match("%.js$") then
        -- Current file is source, try to find test files
        local base = path:gsub("%.ts$", ""):gsub("%.js$", "")
        local ext = path:match("%.ts$") and ".ts" or ".js"

        local test_variants = {
          base .. ".test" .. ext,
          base .. ".integration.test" .. ext,
          base .. ".e2e.test" .. ext,
          base .. ".spec" .. ext,
        }

        for _, test_file in ipairs(test_variants) do
          if vim.fn.filereadable(test_file) == 1 then
            vim.cmd("edit " .. test_file)
            return
          end
        end

        -- No test file found, offer to create one
        local choice =
          vim.fn.input("No test file found. Create (u)nit/(i)ntegration/(e)2e/(n)one? (n/u/i/e): ")
        if choice == "n" or choice == "" then
          print("No test file created")
        elseif choice == "u" then
          vim.cmd("edit " .. base .. ".test" .. ext)
        elseif choice == "i" then
          vim.cmd("edit " .. base .. ".integration.test" .. ext)
        elseif choice == "e" then
          vim.cmd("edit " .. base .. ".e2e.test" .. ext)
        end
      else
        print("Not a TypeScript or JavaScript file")
      end
    end,
    desc = "[T]oggle TS [t]est file",
    icon = "🔄",
  },
  {
    "<leader>ts",
    function()
      vim.wo.spell = not vim.wo.spell
      vim.cmd("redraw")
      local msg = vim.wo.spell and "Spell check ON" or "Spell check OFF"
      vim.notify(msg)
    end,
    desc = "[T]oggle [s]pell check",
    icon = "📝",
  },
})
