{
  description = "NeoVim config";

  inputs.nix2vim.url = "github:gytis-ivaskevicius/nix2vim";
  inputs.nix2vim.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nix2vim.inputs.flake-utils.follows = "flake-utils";

  #inputs.nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nix2vim,
    }:
    {
      overlays.default = final: prev: { neovim = self.packages.${final.system}.neovim; };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nix2vim.overlay
            (final: prev: {
              vimPlugins = prev.vimPlugins.extend (
                _: _: {
                  #final.neovimUtils.buildNeovimPlugin {
                  isabelle-syn =
                    let
                      pname = "isabelle-syn";
                      version = "2024-02-07";
                    in
                    final.fetchFromGitHub {
                      name = "${pname}-${version}";
                      owner = "Treeniks";
                      repo = "isabelle-syn.nvim";
                      rev = "bdad5814efede6496e1c416e7154ccd5021281a2";
                      sha256 = "9z/TwOPeT1zazywvzm2ajGu8jigkoUoi1gEsnSzjzgY=";
                      meta.homepage = "https://github.com/Treeniks/isabelle-syn.nvim";
                    };
                  isabelle-lsp =
                    let
                      pname = "isabelle-lsp";
                      version = "2024-02-06";
                    in
                    final.fetchFromGitHub {
                      name = "${pname}-${version}";
                      owner = "Treeniks";
                      repo = "isabelle-lsp.nvim";
                      rev = "f35632c86930e71e2517ee7dc0d054e785d64728";
                      sha256 = "0IEkzyX05TVaAEABTRCuKWKMj1GFkrRx9g9u11C31p4=";
                      meta.homepage = "https://github.com/Treeniks/isabelle-lsp.nvim";
                    };
                  harpoon2 =
                    let
                      pname = "harpoon2";
                      version = "2024-04-09";
                    in
                    final.fetchFromGitHub {
                      name = "${pname}-${version}";
                      owner = "ThePrimeagen";
                      repo = "harpoon";
                      rev = "0378a6c428a0bed6a2781d459d7943843f374bce";
                      sha256 = "129d51cp89dir809yakiw0b7kkjqww7s5h437j8ppn1lq7ghg50m";
                      meta.homepage = "https://github.com/Treeniks/isabelle-lsp.nvim";
                    };
                }
              );
              isabelle-emacs =
                let
                  pname = "isabelle-emacs";
                  version = "2024-02-22";
                in
                final.fetchFromGitHub {
                  name = "${pname}-${version}";
                  owner = "m-fleury";
                  repo = "isabelle-emacs";
                  rev = "bd8fd356fbd373ff9e78cea09a58ba6de1d6ccfc";
                  sha256 = "97x+BjFU3+QIAzqiCWArxb21FzdCDjK7TjZr191yX9k=";
                  meta.homepage = "https://github.com/m-fleury/isabelle-emacs";
                };
            })
          ];
        };
      in
      {
        packages = rec {
          neovim = import ./build-nvim.nix { inherit pkgs; };
          default = neovim;
        };
      }
    );
}
