return {
	"telescope.nvim",
	cmd = "Telescope",
	keys = {
		{
			"<leader>tp",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Telescope Find Files",
		},
		{
			"<leader>tg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Telescope Live Grep",
		},
	},
	config = function()
		require("telescope").setup({
			pickers = {
				find_files = {
					hidden = true,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("ui-select")
	end,
}
