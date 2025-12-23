return {
  "minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  after = function()
    require("minuet").setup({
      notify = "debug", -- Temporary debugging
      request_timeout = 2.5,
      throttle = 800, -- Faster for free models
      debounce = 400, -- Quicker response
      provider = "openai_compatible",
      provider_options = {
        openai_compatible = {
          api_key = "OPENCODE_ZEN_API_KEY",
          end_point = "https://opencode.ai/zen/v1/chat/completions", -- Fixed endpoint
          model = "big-pickle", -- Fixed model name
          name = "OpenCode Zen",
        },
      },
      virtualtext = {
        auto_trigger_ft = {}, -- Empty = auto-trigger for all filetypes
        keymap = {
          accept = "<A-A>",    -- Accept whole completion
          accept_line = "<A-a>", -- Accept one line
          accept_n_lines = "<A-z>", -- Accept n lines (prompts for number)
          next = "<A-[>",      -- Next completion
          prev = "<A-]>",      -- Previous completion
          dismiss = "<A-e>",    -- Dismiss completion
        },
      },
    })
  end,
}
