{
  pkgs,
  lib,
  inputs,
}:

with pkgs;
[
  nixfmt-rfc-style
  stylua

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
]
