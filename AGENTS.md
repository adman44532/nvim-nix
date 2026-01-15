# AGENTS.md - Neovim Configuration (nvim-nix)

This is a Neovim configuration managed by Nix flakes, using `lz.n` for lazy plugin loading and Lua for configuration.

## Build, Lint, Test Commands

### Running Neovim
```bash
nix run .#default -- .
```
**Permission required: NO** - User runs this manually for testing.

### Development Shell
```bash
nix develop
```
Enters a shell with Lua, Nix, and language tools available.

### Build and Check
```bash
nix build                                    # Build the package
nix flake check                              # Validate flake syntax
nix fmt                                      # Format flake.nix
```
**Permission required: YES** - Ask before running.

## Code Style Guidelines

### Lua (lua/*.lua files)

**Formatting:**
- 2-space indentation
- 100 character column width
- Trailing commas in table literals
- Use `vim.schedule()` for async operations

**Naming Conventions:**
- Variables and functions: `snake_case`
- Local modules: `local M = {}` pattern
- Plugin return tables: descriptive keys like `priority`, `before`, `after`, `ft`

**Imports:**
```lua
local mod = require("module.path")
local func = mod.function_name
```

**Error Handling:**
- Check file existence with `vim.uv.fs_stat(path)`
- Use `vim.tbl_deep_extend("force", ...)` for config merging
- Handle nil with `if not condition then return end` guards

**Comments:**
- Explain "why", not "what"
- Use `--` for single-line comments
- Document plugin purpose and non-obvious behavior

### Nix (flake.nix, nix files)

**Formatting:**
```bash
alejandra .
```
**Permission required: NO** - Safe to run.

**Style:**
- Use `inherit` for attribute inheritance
- Prefer `lib.genAttrs` over loops
- Use `attrValues` for plugin/provider lists

### Shell Scripts (sh, bash)

```bash
shfmt -w -i 2 file.sh
```
**Permission required: NO** - Safe to run.

### Linting

```bash
deadnix .        # Check for dead code in .nix files
statix .         # Lint nix with recommendations
```
**Permission required: NO** - Safe to run.

## Project Structure

```
lua/
├── config/
│   ├── options.lua      # vim.g and vim.o settings
│   ├── keybinds.lua     # which-key bindings
│   └── autocmds.lua     # autocommands
├── handlers/
│   └── which-key.lua    # which-key registration handler
└── plugins/
    ├── lsp.lua          # LSP servers (nil_ls, lua_ls, etc.)
    ├── conform.lua      # Formatting configuration
    ├── treesitter.lua   # Parser configuration
    └── *.lua            # Individual plugin configs
```

**Plugin File Pattern:**
```lua
return {
  { "plugin-name", priority = 1000 },
  {
    "plugin-name",
    ft = { "filetype" },
    before = function() require("lz.n").trigger_load("dependency") end,
    after = function()
      require("plugin").setup({ ... })
    end,
  },
}
```

## Key Conventions

- **Lazy Loading**: Use `require("lz.n").trigger_load("plugin-name")` before dependent plugins
- **Keybindings**: Register via which-key with icons, descriptions, and `<leader>` prefix
- **LSP Setup**: Merge server config with `vim.tbl_deep_extend("force", capabilities, server_config)`
- **Diagnostics**: Disable virtual text when using tiny-inline-diagnostic

## Development Environment Tools

Available in `nix develop` shell:

**Language Servers:** lua-language-server, bash-language-server, yaml-language-server, marksman, fish-lsp, vscode-langservers-extracted

**Formatters:** stylua (Lua), alejandra (Nix), prettierd (JS/TS/JSON/CSS/HTML/markdown), shfmt (sh/bash)

**Linters:** deadnix, statix

**Utilities:** ripgrep, nil (Nix LSP), fzf, fd, xclip, lsof, mcp-hub

## Permission Protocol

**Ask before running:**
- `nix run` (except the user's test command)
- `nix develop`
- `nix build`
- `nix flake check`
- Any command that modifies files beyond formatting/linting

**No permission needed:**
- Formatting: `stylua`, `alejandra`, `prettierd`, `shfmt`
- Linting: `deadnix`, `statix`
- Information gathering: reading files, grep, file search

**Testing:**
User tests changes manually with: `nix run .#default -- .`
