{
  description = "Setup LazyVim using NixVim";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.nixvim.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixvim.inputs.flake-parts.follows = "flake-parts";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

  outputs = { self, nixpkgs, nixvim, flake-parts } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = { pkgs, lib, system, ... }:
        let
          config = {
            extraPackages = with pkgs; [
              # LazyVim
              lua-language-server
              stylua
              # Telescope
              ripgrep
            ];

            extraPlugins = [ pkgs.vimPlugins.lazy-nvim ];

            extraConfigLua =
              let
                plugins = with pkgs.vimPlugins; [
                  # LazyVim
                  LazyVim
                  bufferline-nvim
                  cmp-buffer
                  cmp-nvim-lsp
                  cmp-path
                  cmp_luasnip
                  conform-nvim
                  dashboard-nvim
                  dressing-nvim
                  flash-nvim
                  friendly-snippets
                  gitsigns-nvim
                  indent-blankline-nvim
                  lualine-nvim
                  neo-tree-nvim
                  neoconf-nvim
                  neodev-nvim
                  noice-nvim
                  nui-nvim
                  nvim-cmp
                  nvim-lint
                  nvim-lspconfig
                  nvim-notify
                  nvim-spectre
                  nvim-treesitter
                  nvim-treesitter-context
                  nvim-treesitter-textobjects
                  nvim-ts-autotag
                  nvim-ts-context-commentstring
                  nvim-web-devicons
                  persistence-nvim
                  plenary-nvim
                  telescope-fzf-native-nvim
                  telescope-nvim
                  todo-comments-nvim
                  tokyonight-nvim
                  trouble-nvim
                  vim-illuminate
                  vim-startuptime
                  which-key-nvim
                  { name = "LuaSnip"; path = luasnip; }
                  { name = "catppuccin"; path = catppuccin-nvim; }
                  { name = "mini.ai"; path = mini-nvim; }
                  { name = "mini.bufremove"; path = mini-nvim; }
                  { name = "mini.comment"; path = mini-nvim; }
                  { name = "mini.indentscope"; path = mini-nvim; }
                  { name = "mini.pairs"; path = mini-nvim; }
                  { name = "mini.surround"; path = mini-nvim; }
                ];
                mkEntryFromDrv = drv:
                  if lib.isDerivation drv then
                    { name = "${lib.getName drv}"; path = drv; }
                  else
                    drv;
                lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
              in
              ''
                require("lazy").setup({
                  defaults = {
                    lazy = true,
                  },
                  dev = {
                    -- reuse files from pkgs.vimPlugins.*
                    path = "${lazyPath}",
                    patterns = { "." },
                    -- fallback to download
                    fallback = true,
                  },
                  spec = {
                    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
                    -- The following configs are needed for fixing lazyvim on nix
                    -- force enable telescope-fzf-native.nvim
                    { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
                    -- disable mason.nvim, use config.extraPackages
                    { "williamboman/mason-lspconfig.nvim", enabled = false },
                    { "williamboman/mason.nvim", enabled = false },
                    -- uncomment to import/override with your plugins
                    -- { import = "plugins" },
                    -- put this line at the end of spec to clear ensure_installed
                    { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
                  },
                })
              '';
          };
          nixvim' = nixvim.legacyPackages."${system}";
          nvim = nixvim'.makeNixvim config;
        in
        {
          packages = {
            inherit nvim;
            default = nvim;
          };
        };
    };
}
