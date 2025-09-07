-- Function to create a Telescope picker for browsing folders and opening them with oil.nvim
-- This version uses 'fd' for much better performance.
local function browse_folders_with_oil()
  -- Defer the require calls until this function is actually executed.
  -- By the time a user presses the keymap, all plugins will have been loaded.
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local finders = require("telescope.finders")
  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values

  -- Make sure fd is available
  if vim.fn.executable("fd") == 0 then
    print("Error: 'fd' command not found. Please install it.")
    return
  end

  local find_command = { "fd", "--type", "d" }

  pickers
    .new({}, {
      prompt_title = "Browse Folders (Open with oil.nvim)",
      finder = finders.new_oneshot_job(find_command, {
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry,
            ordinal = entry,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          require("oil").open(selection.value)
        end)
        return true
      end,
    })
    :find()
end

local function get_theme()
  return require("telescope.themes").get_dropdown({
    layout_config = {
      preview_cutoff = 1,
      width = function(_, max_columns, _)
        return math.min(math.floor(max_columns * 0.8), 120)
      end,
      height = function(_, _, max_lines)
        return math.min(math.floor(max_lines * 0.6), 20)
      end,
    },
  })
end
return {
  { "telescope-fzf-native.nvim", priority = 1000 },
  { "telescope-undo.nvim", priority = 1000 },
  { "telescope-ui-select.nvim", priority = 1000 },
  {
    "telescope.nvim",
    before = function()
      require("lz.n").trigger_load("telescope-undo.nvim")
      require("lz.n").trigger_load("telescope-fzf-native.nvim")
      require("lz.n").trigger_load("telescope-ui-select.nvim")
      require("lz.n").trigger_load("nvim-web-devicons")
    end,
    after = function()
      local telescope = require("telescope")
      telescope.setup({
        pickers = {
          theme = "ivy",
          find_files = {
            hidden = false,
          },
        },
        extensions = {
          ["ui-select"] = {
            get_theme(),
          },
          undo = {
            use_delta = true,
            side_by_side = true,
          },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("fzf")
      telescope.load_extension("undo")
    end,
    cmd = "Telescope",
    binds = {
      {
        "<leader>sh",
        function()
          require("telescope.builtin").help_tags(get_theme())
        end,
        desc = "[S]earch [H]elp",
      },
      {
        "<leader>sk",
        function()
          require("telescope.builtin").keymaps(get_theme())
        end,
        desc = "[S]earch [K]eymaps",
      },
      {
        "<leader>sf",
        function()
          require("telescope.builtin").find_files(get_theme())
        end,
        desc = "[S]earch [F]iles",
      },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").builtin(get_theme())
        end,
        desc = "[S]earch [S]elect Telescope",
      },
      {
        "<leader>sw",
        function()
          require("telescope.builtin").grep_string(get_theme())
        end,
        desc = "[S]earch current [W]ord",
      },
      {
        "<leader>sg",
        function()
          require("telescope.builtin").live_grep(get_theme())
        end,
        desc = "[S]earch by [G]rep",
      },
      { "<leader>sd", browse_folders_with_oil, desc = "[S]earch [D]irectories" },
      -- { '<leader>sd',       function() require('telescope.builtin').diagnostics(get_theme()) end, desc = '[S]earch [D]iagnostics' },
      {
        "<leader>sr",
        function()
          require("telescope.builtin").resume(get_theme())
        end,
        desc = "[S]earch [R]esume",
      },
      {
        "<leader>s.",
        function()
          require("telescope.builtin").oldfiles(get_theme())
        end,
        desc = '[S]earch Recent Files ("." for repeat)',
      },
      {
        "<leader><leader>",
        function()
          require("telescope.builtin").buffers(get_theme())
        end,
        desc = "[ ] Find existing buffers",
      },
      -- Advanced examples with custom configurations merged with theme
      {
        "<leader>/",
        function()
          local dropdown_theme = require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          })
          require("telescope.builtin").current_buffer_fuzzy_find(dropdown_theme)
        end,
        desc = "[/] Fuzzily search in current buffer",
      },

      {
        "<leader>s/",
        function()
          local live_grep_config = vim.tbl_deep_extend("force", get_theme(), {
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          })
          require("telescope.builtin").live_grep(live_grep_config)
        end,
        desc = "[S]earch [/] in Open Files",
      },

      {
        "<leader>sn",
        function()
          local config_search = vim.tbl_deep_extend("force", get_theme(), {
            cwd = vim.fn.stdpath("config"),
          })
          require("telescope.builtin").find_files(config_search)
        end,
        desc = "[S]earch [N]eovim files",
      },

      {
        "<leader>su",
        desc = "[S]earch [U]ndo History",
        function()
          require("telescope").extensions.undo.undo(get_theme())
        end,
      },
    },
  },
}
