{ pkgs, inputs }:
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

    pyright

    (python3.withPackages (
      ps:
      with ps;
      [
        python-lsp-server
        (python-lsp-black.override { pytestCheckHook = null; }) # didnt build with tests enabled :shrug:
        pyls-isort
        pylsp-mypy
      ]
      ++ python-lsp-server.optional-dependencies.all
    ))

    # c
    clang-tools
    #libclang
    #llvmPackages.clang-unwrapped
    #clang
    #llvmPackages.libcxxClang
    ##llvmPackages.libcClang
    #llvmPackages.libllvm
    gdb

    texlab

    # ocaml
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat
    dune_3 # otherwise sometimes the lsp wont work

    #java-language-server
    jdt-language-server

    # go
    go
    delve
    gopls
  ];

  plugins = with pkgs.vimPlugins; [
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

    telescope-nvim

    nvim-treesitter
    #playground # treesitter playground
    nvim-treesitter-context
    # nvim-treesitter-textobjects # i dont need this

    # Link together all treesitter grammars into single derivation
    # for some reason we need to do this
    (pkgs.symlinkJoin {
      name = "nix-treesitter-parsers";
      paths = nvim-treesitter.withAllGrammars.dependencies;
    })


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
    {
      name = "config";
      outPath = "${./config}";
    }
  ];

  extraEnvVars = {
    JAVA_SE_17 = "${pkgs.jdk17}/lib/openjdk";
    # https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
    ECLIPSE_JAVA_GOOGLE_STYLE = "${inputs.google-styleguide}/eclipse-java-google-style.xml";
    VSCODE_JAVA_DEBUG_PATH = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
    #VSCODE_JAVA_TEST_PATH = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test";
    # wait until at least vscode-java-test 0.41 is out (https://github.com/microsoft/vscode-java-test/issues/1681)
    VSCODE_JAVA_TEST_PATH =
      let vscode-java-test = with pkgs; vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-test";
          publisher = "vscjava";
          version = "0.42.2024080106";
          hash = "sha256-bg6ckBp8VJwXDp877wqt4MAyBPNJZWog/aEptbSaPg4=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };
      in
      "${vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test";
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
