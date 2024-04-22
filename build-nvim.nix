{ pkgs }:
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

    # isabelle
    isabelle-emacs
    # before usabel u need to do this:
    # https://github.com/m-fleury/isabelle-emacs/blob/Isabelle2023-vsce/src/Tools/emacs-lsp/spacemacs_layers/isabelle/README.org
  ];

  plugins = with pkgs.vimPlugins; [
    # theme
    rose-pine
    tokyonight-nvim

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
    harpoon2

    # isabelle
    isabelle-syn
    isabelle-lsp

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
    #vim-nix # i dont use this

    # personal config
    {
      name = "config";
      outPath = "${./config}";
    }
  ];

  extraEnvVars =
    let
      JAVA_SE_17 = "${pkgs.jdk17}/lib/openjdk";
    in
    {
      inherit JAVA_SE_17;
      JAVA_HOME = JAVA_SE_17;
      ECLIPSE_JAVA_GOOGLE_STYLE = pkgs.fetchurl {
        url = "https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml";
        hash = "sha256-mCgDIoRLQWQUOwHOQwuzc2BngvtMpvFmdESuKyHPvGE=";
      };
    };

  extraMakeWrapperArgsPath = ''--suffix PATH : "${pkgs.lib.makeBinPath extraPackages}"'';
  extraMakeWrapperArgsEnvVars = builtins.concatStringsSep " " (
    pkgs.lib.mapAttrsToList (name: value: ''--set ${name} ${value}'') extraEnvVars
  );
in
pkgs.neovimBuilder {
  inherit plugins;

  # packages needed
  extraMakeWrapperArgs = extraMakeWrapperArgsPath + " " + extraMakeWrapperArgsEnvVars;
}
