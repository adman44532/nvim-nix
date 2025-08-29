return {
  "avante.nvim",
  before = function()
    require("lz.n").trigger_load("mcphub.nvim")
    require("lz.n").trigger_load("nui.nvim")
    require("lz.n").trigger_load("telescope.nvim")
    require("lz.n").trigger_load("copilot.lua")
    require("lz.n").trigger_load("nvim-web-dev-icons")
    require("lz.n").trigger_load("render-markdown.nvim")
  end,
  after = function()
    require("avante").setup({
      provider = "copilot",
      -- system_prompt as function ensures LLM always has latest MCP server state
      -- This is evaluated for every message, even in existing chats
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ""
      end,
      -- Using function prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
    })
  end,
}
