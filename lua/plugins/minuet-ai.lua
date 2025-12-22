return {
  {
    "minuet-ai.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("minuet").setup({
        provider = "openai_compatible",
        provider_options = {
          openai_compatible = {
            api_key = vim.env.OPENCODE_ZEN_API_KEY or "your_api_key_here", -- Set in shell or replace here
            end_point = "https://api.opencode.ai/v1/chat/completions", -- Verify this endpoint
            model = "big-pickle", -- Big Pickle model
            name = "Big Pickle",
          },
        },
      })
    end,
  },
}
