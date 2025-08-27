return {
  "mcphub.nvim",
  -- build = "bundled_build.lua",
  after = function()
    require("mcphub").setup({
      -- use_bundled_binary = true,
      cmd = "mcp-hub",
    })
  end,
}
