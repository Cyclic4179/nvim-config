{ lib, ... }@args:

let
  extraPackages = import ./extra-packages.nix args;
  extraPlugins = import ./extra-plugins.nix args;
  globalVars = import ./global-vars.nix args;

  globalVarsString = builtins.concatStringsSep "\n" (
    lib.mapAttrsToList (name: value: ''vim.g.${name} = "${value}"'') globalVars
  );

in
{
  extraPackages = extraPackages;
  vimPlugins = extraPlugins;
  lua = globalVarsString;
}
