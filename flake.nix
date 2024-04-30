{
  description = "NeoVim config";

  inputs.nix2vim.url = "github:gytis-ivaskevicius/nix2vim";
  inputs.nix2vim.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nix2vim.inputs.flake-utils.follows = "flake-utils";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nix2vim,
    }:
    {
      overlays.default = final: prev: {
        neovim = self.packages.${final.system}.neovim;
      };
    } //
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nix2vim.overlay ];
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
