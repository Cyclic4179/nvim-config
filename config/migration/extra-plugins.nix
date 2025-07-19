{
  pkgs,
  lib,
  inputs,
}:

with pkgs.vimPlugins;
[
  #LazyVim

  vim-repeat

  # theme
  # until nixpkgs has newer rose-pine version (needed for customizing text color)
  rose-pine
  # (pkgs.vimUtils.buildVimPlugin {
  #   pname = "rose-pine";
  #   version = "2024-08-25";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "rose-pine";
  #     repo = "neovim";
  #     rev = "8b1fd252255a7f2c41b4192a787ab62660b29f72";
  #     sha256 = "sha256-KYlt0ryKTBV5vimnq3rxEQOhkiqLK/EV7zMxVNdSUTY=";
  #   };
  #   meta.homepage = "https://github.com/rose-pine/neovim/";
  # })
  tokyonight-nvim

  # icons -> for oil-nvim, telescope-nvim
  nvim-web-devicons

  # trying out ...
  trouble-nvim
  # (pkgs.vimUtils.buildVimPlugin {
  #   pname = "local-highlight.nvim";
  #   version = "2024-04-20";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "tzachar";
  #     repo = "local-highlight.nvim";
  #     rev = "ae3ada3a332128b1036c84c8587b9069891c63da";
  #     sha256 = "sha256-JeTZrf1O3bAtrL857Khiqij8qSZfKp7lzAmnuxXREnE=";
  #   };
  #   meta.homepage = "https://github.com/tzachar/local-highlight.nvim";
  # })

  which-key-nvim

  plenary-nvim
  telescope-nvim

  nvim-treesitter
  #nvim-treesitter.withAllGrammars
  #playground # treesitter playground
  nvim-treesitter-context
  #(pkgs.vimUtils.buildVimPlugin {
  #  pname = "nvim-treesitter-context";
  #  version = "2024-10-04";
  #  src = pkgs.fetchFromGitHub {
  #    owner = "nvim-treesitter";
  #    repo = "nvim-treesitter-context";
  #    rev = "78a81c7494e7d1a08dd1200b556933e513fd9f29";
  #    sha256 = "sha256-7NrWuN8uzS8fS9WGp3tBF6IpA7oeK64+f8+euCkPbqc=";
  #  };
  #  meta.homepage = "https://github.com/nvim-treesitter/nvim-treesitter-context/";
  #})
  # nvim-treesitter-textobjects # i dont need this

  # Link together all treesitter grammars into single derivation
  # for some reason we need to do this
  #(pkgs.symlinkJoin {
  #  name = "nix-treesitter-parsers";
  #  paths = nvim-treesitter.withAllGrammars.dependencies;
  #})

  mini-nvim

  leap-nvim
  hop-nvim
  flash-nvim

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
  # nvim-highlight-colors
  nvim-colorizer-lua

  # harpoon
  harpoon2

  # completion
  nvim-cmp
  cmp-buffer
  cmp-calc
  otter-nvim
  cmp-path
  cmp-cmdline
  cmp-nvim-lua
  cmp-emoji
  cmp-latex-symbols
  (pkgs.vimUtils.buildVimPlugin {
    pname = "cmp_luasnip_choice";
    version = "2023-03-06";
    src = pkgs.fetchFromGitHub {
      owner = "L3MON4D3";
      repo = "cmp-luasnip-choice";
      rev = "4f49232e51c9df379b9daf43f25f7ee6320450f0";
      sha256 = "sha256-/s1p/WLfrHZHX6fU1p2PUQ0GIocAB4mvhjZ0XUMzkaw=";
    };
    meta.homepage = "https://github.com/L3MON4D3/cmp-luasnip-choice";
    dependencies = [ nvim-cmp ];
  })
  lspkind-nvim

  # lsp
  nvim-lspconfig
  cmp-nvim-lsp
  cmp-nvim-lsp-signature-help
  cmp-nvim-lua

  # snippets
  luasnip
  cmp_luasnip
  friendly-snippets

  # formatting

  # debugger
  nvim-dap-ui
  nvim-dap
  nvim-nio # required for some reason
  nvim-dap-virtual-text
  nvim-dap-go
]
