{ pkgs }:
pkgs.neovimBuilder {

  # packages needed
  extraMakeWrapperArgs =
    let
      extraPackages = with pkgs; [
        # search
        ripgrep
        fd # suggested by telescope-nvim heathcheck

        # unzip
        unzip

        # lsp
        # nix
        nil

        rust-analyzer

        nodePackages_latest.dockerfile-language-server-nodejs
        #nodePackages.eslint
        nodePackages.typescript-language-server
        lua-language-server

        nodePackages.pyright

        python311Packages.python-lsp-server
        python311Packages.python-lsp-ruff

        clang-tools
        #libclang
        #llvmPackages.clang-unwrapped
        #clang
        #llvmPackages.libcxxClang
        ##llvmPackages.libcClang
        #llvmPackages.libllvm

        texlab

        # ocaml
        ocamlPackages.ocaml-lsp
        ocamlPackages.ocamlformat

        #java-language-server
        jdt-language-server
      ];
    in
    ''--suffix PATH : "${pkgs.lib.makeBinPath extraPackages}"'';

  plugins = with pkgs.vimPlugins; [
    # theme
    rose-pine

    telescope-nvim

    nvim-treesitter.withAllGrammars
    playground # treesitter playground
    nvim-treesitter-context

    undotree

    # java lsp
    #nvim-jdtls # annoying config (cant with lspconfig, didnt investigate further)
    nvim-jdtls

    # tpope/vim-fugitive
    vim-fugitive

    # harpoon
    harpoon

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

    # nix file detection
    vim-nix

    # personal config
    {
      name = "config";
      outPath = "${./config}";
    }
  ];
}
