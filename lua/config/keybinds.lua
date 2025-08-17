-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic popup' })
vim.keymap.set('n', '[d', function()
	vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic' })

vim.keymap.set('n', ']d', function()
	vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic' })

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- Move current line down in normal mode
vim.keymap.set('n', '<C-j>', ':m .+1<CR>==', { desc = 'Move line down' })

-- Move current line up in normal mode
vim.keymap.set('n', '<C-k>', ':m .-2<CR>==', { desc = 'Move line up' })

-- Move selected block down in visual mode
vim.keymap.set('x', '<C-j>', ":m '>+1<CR>gv=gv", { desc = 'Move block down' })

-- Move selected block up in visual mode
vim.keymap.set('x', '<C-k>', ":m '<-2<CR>gv=gv", { desc = 'Move block up' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Jump between source ↔ test with creation option
local function toggle_test_file()
	local path = vim.api.nvim_buf_get_name(0)

	-- Check if current file is a test file
	if path:match '%.e2e%.test%.ts$' or path:match '%.e2e%.test%.js$' then
		local src = path:gsub('%.e2e%.test%.ts$', '.ts'):gsub('%.e2e%.test%.js$', '.js')
		vim.cmd('edit ' .. src)
	elseif path:match '%.integration%.test%.ts$' or path:match '%.integration%.test%.js$' then
		local src = path:gsub('%.integration%.test%.ts$', '.ts'):gsub('%.integration%.test%.js$', '.js')
		vim.cmd('edit ' .. src)
	elseif path:match '%.test%.ts$' or path:match '%.test%.js$' then
		local src = path:gsub('%.test%.ts$', '.ts'):gsub('%.test%.js$', '.js')
		vim.cmd('edit ' .. src)
	elseif path:match '%.spec%.ts$' or path:match '%.spec%.js$' then
		local src = path:gsub('%.spec%.ts$', '.ts'):gsub('%.spec%.js$', '.js')
		vim.cmd('edit ' .. src)
	elseif path:match '%.ts$' or path:match '%.js$' then
		-- Current file is source, try to find test files
		local base = path:gsub('%.ts$', ''):gsub('%.js$', '')
		local ext = path:match '%.ts$' and '.ts' or '.js'

		local test_variants = {
			base .. '.test' .. ext,
			base .. '.integration.test' .. ext,
			base .. '.e2e.test' .. ext,
			base .. '.spec' .. ext,
		}

		for _, test_file in ipairs(test_variants) do
			if vim.fn.filereadable(test_file) == 1 then
				vim.cmd('edit ' .. test_file)
				return
			end
		end

		-- No test file found, offer to create one
		local choice = vim.fn.input 'No test file found. Create (u)nit/(i)ntegration/(e)2e/(n)one? (n/u/i/e): '
		if choice == 'n' or choice == '' then
			print 'No test file created'
		elseif choice == 'u' then
			vim.cmd('edit ' .. base .. '.test' .. ext)
		elseif choice == 'i' then
			vim.cmd('edit ' .. base .. '.integration.test' .. ext)
		elseif choice == 'e' then
			vim.cmd('edit ' .. base .. '.e2e.test' .. ext)
		end
	else
		print 'Not a TypeScript or JavaScript file'
	end
end

-- Map it (e.g. <leader>tf)
vim.keymap.set('n', '<leader>tt', toggle_test_file, { desc = '[T]oggle TS [t]est file' })

vim.keymap.set('n', '<leader>ts', function()
	vim.wo.spell = not vim.wo.spell
	vim.cmd 'redraw' -- Ensures immediate screen redraw[1]
	local msg = vim.wo.spell and 'Spell check ON' or 'Spell check OFF'
	vim.notify(msg)
end, { desc = '[T]oggle [s]pell check' })
