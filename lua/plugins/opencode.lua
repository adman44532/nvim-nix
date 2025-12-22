return {
  {
    "opencode.nvim",
    event = "DeferredUIEnter",
    after = function()
      vim.g.opencode_opts = {
        provider = {
          enabled = "terminal",
          terminal = {
            split = "right",
            width = math.floor(vim.o.columns * 0.35),
          },
        },
      }
      vim.o.autoread = true

      vim.keymap.set({ "n", "x" }, "<leader>oa", function()
        require("opencode").ask("@this:  ", { submit = true })
      end, { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>os", function()
        require("opencode").select()
      end, { desc = "opencode select…" })
      vim.keymap.set({ "n", "t" }, "<leader>ot", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })
      vim.keymap.set({ "n", "x" }, "go", function()
        return require("opencode").operator("@this ")
      end, { expr = true, desc = "Add range to opencode" })
      vim.keymap.set("n", "goo", function()
        return require("opencode").operator("@this ") .. "_"
      end, { expr = true, desc = "Add line to opencode" })
    end,
  },
}
