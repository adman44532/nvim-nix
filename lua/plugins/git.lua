return {
  {
    "diffview.nvim",
  },
  {
    "gitsigns.nvim",
    event = "BufReadPre",
    after = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
    end,
  },
  {
    "neogit",
    before = function()
      require("lz.n").trigger_load("diffview.nvim")
      require("lz.n").trigger_load("telescope.nvim")
    end,
    after = function()
      local neogit = require("neogit")
      vim.keymap.set(
        "n",
        "<leader>gs",
        neogit.open,
        { silent = true, noremap = true, desc = "[g]it [s]creen Open" }
      )

      vim.keymap.set(
        "n",
        "<leader>gp",
        ":Neogit pull<CR>",
        { silent = true, noremap = true, desc = "[g]it [p]ull" }
      )

      vim.keymap.set("n", "<leader>gB", ":G blame<CR>", { silent = true, noremap = true, desc = "[g]it [B]lame" })
    end,
  },
}
