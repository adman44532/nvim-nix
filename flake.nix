{
  description = "A Neovim Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    mnw,
    neovim-nightly-overlay,
    ...
  }: let
    lib = nixpkgs.lib;
    attrValues = lib.attrsets.attrValues;
  in {
    packages = lib.genAttrs lib.platforms.all (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = mnw.lib.wrap pkgs {
          appName = "nvim";
          neovim = neovim-nightly-overlay.packages.${system}.neovim;

          extraBinPath = attrValues {
            inherit
              (pkgs)
              lua-language-server
              bash-language-server
              marksman
              deadnix
              ripgrep
              statix
              nil
              fzf
              fd
              ;
          };

          # Creates a init.lua in the root level
          # lz.n is able to load from a module without init.lua
          initLua = ''
            require('config.options')
            require('config.keybinds')
            require('config.autocmds')
            require('lz.n').load('plugins')
          '';

          # Aims to mirror Neovim's default plugin setup, but allows us to provide the binaries through nixpkgs
          plugins = {
            start = with pkgs.vimPlugins; [
              lz-n
              plenary-nvim
            ];

            # Anything that you're loading lazily should be put here
            opt = with pkgs.vimPlugins;
              [
                oil-nvim
                catppuccin-nvim
                telescope-nvim
                telescope-fzf-native-nvim
                telescope-ui-select-nvim
                telescope-undo-nvim
                mini-ai
                mini-surround
                mini-comment
                mini-pairs
                mini-indentscope
                mini-statusline
                gitsigns-nvim
                nvim-web-devicons
                render-markdown-nvim
                todo-comments-nvim
                avante-nvim
                grug-far-nvim
                neogit
                nvim-treesitter
                nvim-treesitter-context
                nvim-treesitter-textobjects
                nvim-lspconfig
                fidget-nvim
                blink-cmp
                blink-cmp-avante
                conform-nvim
                which-key-nvim
                none-ls-nvim
                luasnip
                friendly-snippets
                lazydev-nvim
                  tiny-inline-diagnostic-nvim
                  diffview-nvim
              ]
              ++ (attrValues {
                inherit (pkgs.vimPlugins.nvim-treesitter) withAllGrammars;
              });

            dev.myconfig = {
              # you can use lib.fileset to reduce rebuilds here
              # https://noogle.dev/f/lib/fileset/toSource
              pure = ./.;
              impure =
                # This is a hack it should be a absolute path
                # here it'll only work from this directory
                "/home/adman/Projects/nvim/";
            };
          };
        };

        dev = self.packages.x86_64-linux.default.devMode;
      }
    );
  };
}
