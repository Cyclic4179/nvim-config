{
  description = "NeoVim config";

  inputs.nix2vim.url = "github:gytis-ivaskevicius/nix2vim";
  inputs.nix2vim.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nix2vim.inputs.flake-utils.follows = "flake-utils";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  inputs.google-styleguide.url = "github:google/styleguide/gh-pages";
  inputs.google-styleguide.flake = false;

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nix2vim,
      google-styleguide
    }:
    {
      overlays.default = final: prev: { neovim = self.packages.${final.system}.neovim; };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nix2vim.overlay ];
        };
        neovim = import ./build-nvim.nix { inherit pkgs google-styleguide; };
      in
      {
        apps.default = flake-utils.lib.mkApp {
          drv = neovim;
          name = "nvim";
        };
        packages = {
          neovim = neovim;
          default = neovim;
        };
      }
    );
}
