{
  description = "My Universal Neovim Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    mcp-hub.url = "github:ravitemer/mcp-hub";
    mcp-hub-nvim.url = "github:ravitemer/mcphub.nvim";
  };

  outputs = {
    self,
    nixpkgs,
    mnw,
    neovim-nightly-overlay,
    mcp-hub,
    mcp-hub-nvim,
    ...
  }: let
    inherit (nixpkgs) lib;
    inherit (lib.attrsets) attrValues;
  in {
    packages = lib.genAttrs lib.platforms.all (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = mnw.lib.wrap pkgs {
          appName = "nvim";
          inherit (neovim-nightly-overlay.packages.${system}) neovim;

          providers.nodeJs.enable = true;

          extraBinPath = attrValues {
            # LSP
            inherit
              (pkgs)
              lua-language-server
              bash-language-server
              yaml-language-server
              vscode-langservers-extracted
              fish-lsp
              marksman
              ;

            # Linters
            inherit
              (pkgs)
              stylua
              alejandra
              prettierd
              deadnix
              statix
              shfmt
              ;

            # Utils
            inherit
              (pkgs)
              ripgrep
              nil
              fzf
              fd
              xclip
              lsof
              ;

            mcp-hub = mcp-hub.packages.${system}.default;
          };

          # Creates a init.lua in the root level
          # lz.n is able to load from a module without init.lua
          initLua = ''
            require('config.options')
            require('lz.n').register_handler(require('handlers.which-key'))
            require('config.keybinds')
            require('config.autocmds')
            require('lz.n').load('plugins')
          '';

          # Aims to mirror Neovim's default plugin setup, but allows us to provide the binaries through nixpkgs
          plugins = {
            start = with pkgs.vimPlugins;
              [
                lz-n
                which-key-nvim
                plenary-nvim
                nvim-treesitter
                oil-nvim
                catppuccin-nvim
                snacks-nvim
              ]
              ++ (attrValues {
                inherit (pkgs.vimPlugins.nvim-treesitter) withAllGrammars;
              });

            # Anything that you're loading lazily should be put here
            opt = with pkgs.vimPlugins; [
              gitsigns-nvim
              blink-cmp
              nvim-lspconfig
              friendly-snippets
              lazydev-nvim
              render-markdown-nvim
              todo-comments-nvim
              conform-nvim
              opencode-nvim
              mini-icons
              lualine-nvim

              # DAP (Debug Adapter Protocol)
              nvim-dap
              nvim-dap-ui
              nvim-nio
              nvim-dap-python
            ];
            # ++ [mcp-hub-nvim.packages.${system}.default]

            dev.myconfig = {
              # you can use lib.fileset to reduce rebuilds here
              # https://noogle.dev/f/lib/fileset/toSource
              pure = ./.;
              impure =
                # This is a hack it should be a absolute path
                # here it'll only work from this directory
                "/home/adman/Projects/nvim-nix/";
            };
          };
        };

        dev = self.packages.x86_64-linux.default.devMode;
      }
    );
  };
}
