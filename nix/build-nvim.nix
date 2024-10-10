{
  pkgs,
  lib,
  inputs,
}@args:

let
  inherit (import ./lib.nix args) prettyTraceDebug prettyTraceIdDebug;

  recMapNix = import ./map.nix args;

  lazy-plugins = prettyTraceIdDebug "recMapNix test" (recMapNix "lua/plugins" ../plugins);
  config = prettyTraceIdDebug "recMapNix config" (recMapNix "" ../config);

  finalVimPlugins = lazy-plugins.vimPlugins ++ config.vimPlugins;
  finalExtraPackages = lazy-plugins.extraPackages ++ config.extraPackages;

  pluginPath = pkgs.linkFarm "lazyvim-nix-plugins" (builtins.map mkEntryFromDrv finalVimPlugins);

  mkEntryFromDrv =
    drv:
    if lib.isDerivation drv then
      {
        name = "${lib.getName drv}";
        path = drv;
      }
    else
      drv;

  luaConfigFile = prettyTraceIdDebug "luaConfigFile" (recCatContent config.luaCfg);

  recCatContent =
    path:
    prettyTraceDebug "recCatContent called" path (
      pkgs.runCommand "recursive-cat" { } ''
        find ${path} -type f -follow -exec cat {} + > $out
      ''
    );

  # paths to executables that should be available when running nvim
  extraMakeWrapperArgsPath =
    let
      binPath = lib.makeBinPath finalExtraPackages;
    in
    [
      "--suffix"
      "PATH"
      ":"
      binPath
    ];

  # TODO: local path references are useless (?) in *.lua.nix files
  # TODO: if i want to move this, i need to provide a `final` or sth argument
  # maybe use lib.fix for this
  # see https://github.com/hsjobeki/nixpkgs/blob/migrate-doc-comments/pkgs/applications/editors/neovim/wrapper.nix
  # copied from https://github.com/nvim-neorocks/rocks.nvim/blob/b24f15ace8542882946222bbc2be332ed57a0861/nix/plugin-overlay.nix#L196
  neovimConfig = prettyTraceIdDebug "neovimConfig" (
    pkgs.neovimUtils.makeNeovimConfig {
      withPython3 = false;
      withNodeJs = false;
      withRuby = false;

      viAlias = false;
      vimAlias = true;

      plugins = [ pkgs.vimPlugins.lazy-nvim ];
    }
  );
  neovimWrapped = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
    neovimConfig
    // {
      luaRcContent =
        # lua
        ''
          -- config
          ${builtins.readFile luaConfigFile}
        ''
        + import ../init.lua.nix (
          args
          // {
            inherit pluginPath;
            pluginDir = lazy-plugins.luaCfg;
          }
        );
      wrapRc = true; # sets -u <vimrc> (and hence ignores local .vimrc, ...)
      wrapperArgs = neovimConfig.wrapperArgs ++ extraMakeWrapperArgsPath;
      neovimRcContent = if neovimConfig.neovimRcContent == "" then null else neovimConfig.neovimRcContent;
    }
  );
in

neovimWrapped
