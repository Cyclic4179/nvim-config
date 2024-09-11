{
  pkgs,
  lib,
  inputs,
}:

with pkgs.vimPlugins;
[
  #LazyVim

  # theme
  # until nixpkgs has newer rose-pine version
  #rose-pine
  (pkgs.vimUtils.buildVimPlugin {
    pname = "rose-pine";
    version = "2024-08-25";
    src = pkgs.fetchFromGitHub {
      owner = "rose-pine";
      repo = "neovim";
      rev = "8b1fd252255a7f2c41b4192a787ab62660b29f72";
      sha256 = "sha256-KYlt0ryKTBV5vimnq3rxEQOhkiqLK/EV7zMxVNdSUTY=";
    };
    meta.homepage = "https://github.com/rose-pine/neovim/";
  })
  tokyonight-nvim

  # icons -> for oil-nvim, telescope-nvim
  nvim-web-devicons

  # trying out ...
  trouble-nvim

  telescope-nvim

  nvim-treesitter
  #nvim-treesitter.withAllGrammars
  #playground # treesitter playground
  nvim-treesitter-context
  # nvim-treesitter-textobjects # i dont need this

  # Link together all treesitter grammars into single derivation
  # for some reason we need to do this
  #(pkgs.symlinkJoin {
  #  name = "nix-treesitter-parsers";
  #  paths = nvim-treesitter.withAllGrammars.dependencies;
  #})

  nvim-autopairs

  undotree

  # java lsp
  #nvim-jdtls # annoying config (cant with lspconfig, didnt investigate further)
  nvim-jdtls

  # tpope/vim-fugitive
  vim-fugitive

  #vim-visual-multi # idk if i want this
  #multicursors-nvim
  #multiple-cursors

  # netrw replacement
  oil-nvim

  conform-nvim
  # doesnt exist in nixpkgs, see this pull request https://github.com/norcalli/nvim-colorizer.lua/pull/104
  (pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-colorizer.lua";
    version = "2024-07-03";
    src = pkgs.fetchFromGitHub {
      owner = "mertkaradayi";
      repo = "nvim-colorizer.lua";
      rev = "23fba8faf199244a480c9d78431e2a4a29aea880";
      sha256 = "sha256-ndJy6Nqjsz+J8aACtyoF2Ks8LZe99tO00EN3mZbShx4=";
    };
    meta.homepage = "https://github.com/norcalli/nvim-colorizer.lua";
  })

  # harpoon
  harpoon2

  # completion
  nvim-cmp
  cmp-buffer
  cmp-calc
  cmp-path
  cmp-cmdline
  cmp-nvim-lua
  # lsp
  nvim-lspconfig
  cmp-nvim-lsp
  cmp-nvim-lsp-signature-help
  cmp-nvim-lua
  # snippets
  luasnip
  cmp_luasnip
  # formatting
  lspkind-nvim

  # debugger
  nvim-dap-ui
  nvim-dap
  nvim-nio # required for some reason
  nvim-dap-virtual-text
  nvim-dap-go

  # nix file detection
  #vim-nix # i dont use this

  # personal config
  #{
  #  name = "config";
  #  outPath = "${./config}";
  #}
]
