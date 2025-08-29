return {
  "copilot.lua",
  after = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-j>", -- Accept suggestion (Ctrl-J)
          next = "<C-n>", -- Next suggestion (Ctrl-N)
          prev = "<C-p>", -- Previous suggestion (Ctrl-P)
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
    })
  end,
  cmd = "Copilot",
  event = "InsertEnter",
}
