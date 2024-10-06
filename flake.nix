{
  description = "NeoVim config";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  # used for java styleguide
  inputs.google-styleguide.url = "github:google/styleguide/gh-pages";
  inputs.google-styleguide.flake = false;

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    {
      overlays.default = [ (final: prev: { neovim = self.packages.${final.system}.neovim; }) ];
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        neovim = import ./nix/build-nvim.nix {
          inherit pkgs inputs;
          lib = pkgs.lib;
        };
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
