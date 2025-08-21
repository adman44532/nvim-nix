return {
	{
		"nvim-treesitter-textobjects",
	},
	{
		"nvim-treesitter-context",
		after = function()
			require("treesitter-context").setup({ enable = true })
		end,
		keys = {
			{
				"<leader>ttc",
				function()
					require("treesitter-context").toggle()
				end,
				desc = "[T]oggle [T]reesitter [C]ontext",
			},
		},
	},
	{
		"nvim-treesitter",
		before = function()
			require("lz.n").trigger_load("nvim-treesitter-textobjects")
			require("lz.n").trigger_load("nvim-treesitter-context")
		end,
		after = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"bash",
					"c",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
					"nix",
					"json",
					"yaml",
					"toml",
					"javascript",
					"typescript",
					"tsx",
					"gitcommit",
				},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "ruby" },
				},
				indent = {
					enable = true,
					disable = { "ruby" },
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
						include_surrounding_whitespace = true,
						selection_modes = {
							["@parameter.outer"] = "v",
							["@function.outer"] = "V",
							["@class.outer"] = "<c-v>",
						},
					},
				},
			})
		end,
	},
}
