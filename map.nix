{ pkgs, lib, ... }@args:
/**
  * expects:
  * string dir, store the mapped filetree under that dir (as in pkgs.writeTextDir)
  * path with files and directories that are:
  *     *.lua -> directly mapped
  *     *.lua.nix that eval to
  *       {
  *         lua :: string
  *         vimPlugins :: list of derivations (vim plugins);
  *         extraPackages :: list of derivations (things that will be added to path);
  *       }
  *     everything else will be ignored
  *
  * returns {
  *   luaCfg = symlinkJoined mapped files in dir;
  *   vimPlugins = list of derivations (vim plugins);
  *   extraPackages = list of derivations (things that will be added to path);
  * }
*/
let
  inherit (import ./lib.nix args) toPrettyString prettyTrace;
  recMapNix =
    let
      merge =
        {
          luaFiles ? [ ],
          vimPlugins ? [ ],
          extraPackages ? [ ],
        }:
        let
          luaFilesA = luaFiles;
          vimPluginsA = vimPlugins;
          extraPackagesA = extraPackages;
        in
        {
          luaFiles ? [ ],
          vimPlugins ? [ ],
          extraPackages ? [ ],
        }:
        {
          luaFiles = luaFilesA ++ luaFiles;
          vimPlugins = vimPluginsA ++ vimPlugins;
          extraPackages = extraPackagesA ++ extraPackages;
        };

      checkAttrStructure =
        {
          lua ? "",
          vimPlugins ? [ ],
          extraPackages ? [ ],
        }:
        # make sure the correct types are used
        assert builtins.isString lua && builtins.isList vimPlugins && builtins.isList extraPackages;
        assert builtins.all lib.isDerivation vimPlugins;
        assert builtins.all lib.isDerivation extraPackages;
        true;

      rmNixSuffix = lib.removeSuffix ".nix";

      # relpath is only for dir in writeTextFile
      getContentNixOrLuaFile =
        relpath: wholepath:
        # prettyTrace "getContentNixOrLuaFile" "${relpath} ${wholepath}" (
        if lib.hasSuffix ".lua.nix" wholepath then
          let
            res = import wholepath args;
          in
          if builtins.isString res then
            {
              luaFiles = [ (pkgs.writeTextDir (rmNixSuffix relpath) res) ];
              vimPlugins = [ ];
              extraPackages = [ ];
            }
          else if builtins.isAttrs res && (builtins.tryEval (checkAttrStructure res)).success then
            {
              luaFiles = if res ? lua then [ (pkgs.writeTextDir (rmNixSuffix relpath) res.lua) ] else [ ];
              vimPlugins = if res ? vimPlugins then res.vimPlugins else [ ];
              extraPackages = if res ? extraPackages then res.extraPackages else [ ];
            }
          else
            # case: *.nix file evaluates to sth else
            throw ''
              expected ${toString wholepath} to evaluate to string
              or { lua :: string , vimPlugins :: [ derivations ... ] , extraPackages :: [ derivations ... ]}
              but was:
              ${toPrettyString res}
            ''
        else if lib.hasSuffix ".lua" wholepath then
          # TODO: lol try to detect dependencies?
          { luaFiles = [ (pkgs.writeTextDir relpath (builtins.readFile wholepath)) ]; }
        else
          lib.warn "ignoring file: ${toString wholepath}" { }
      # )
      ;

      recursiveWalk =
        relpath: wholepath:
        prettyTrace "recursiveWalk called" "${relpath} ${wholepath}" (
          lib.pipe wholepath [
            builtins.readDir
            (lib.mapAttrsToList (
              name: ft:
              let
                newsubp = "${relpath}/${name}";
                newp = "${wholepath}/${name}";
              in
              if ft == "regular" then
                getContentNixOrLuaFile newsubp newp
              else if ft == "directory" then
                recursiveWalk newsubp newp
              else
                lib.warn "unsupported filetype: ${ft} at ${toString wholepath}" { }
            ))
            (builtins.foldl' merge { })
          ]
        );
    in
    recursiveWalk;

  wrapper =
    relpath: wholepath:
    let
      res = recMapNix relpath wholepath;
    in
    prettyTrace "recursiveWalk result" res {
      luaCfg = pkgs.symlinkJoin {
        name = "lua-files";
        paths = res.luaFiles;
      };
      extraPackages = lib.unique res.extraPackages;
      vimPlugins = lib.unique res.vimPlugins;
    };

in
wrapper
