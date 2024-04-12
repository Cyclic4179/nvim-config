{
  description = "NeoVim config";

  inputs.nix2vim.url = "github:gytis-ivaskevicius/nix2vim";
  inputs.nix2vim.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nix2vim.inputs.flake-utils.follows = "flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nix2vim,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nix2vim.overlay ];
        };
      in
      {
        #packages.default = pkgs.nix2vimDemo;
        #apps = import ./apps.nix { inherit pkgs; utils = flake-utils.lib; };
        #checks = import ./checks { inherit pkgs dsl; check-utils = import ./check-utils.nix; };

        #hmModules.nvim = import ./nvim-config.nix;

        packages = rec {
          nvim = import ./build-nvim.nix {inherit pkgs;};
          default = nvim;
        };

        #packages.default = pkgs.hello; # pkgs.neovimBuilder { };
        #  (x: builtins.trace "testing" nixpkgs.legacyPackages.x86_64-linux.hello)
        #    3;
      }
    )
    // {
      #packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    };
}
