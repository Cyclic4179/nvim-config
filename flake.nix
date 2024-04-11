{
  description = "NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      #hmModules.nvim = import ./nvim-config.nix;

      #packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

      packages.x86_64-linux.default =
        (x: builtins.trace "testing" nixpkgs.legacyPackages.x86_64-linux.hello)
          3;
    };
}
