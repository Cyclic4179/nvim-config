# nvim-config

## run with nix flakes

```sh
nix run github:Cyclic4179/nvim-config
```

## template for nix files in ./plugins
```nix
{ pkgs, ... }:
{
  binaries = with pkgs; [
    ...
  ];
  lazy =
    with pkgs.vimPlugins;
    # lua
    ''
      {
        dir = "${plugin}",
        name = "plugin-name", -- this is optional, shown instead of dir when `:Lazy`
        config = function()
            ...
        end
      }, -- this `,` is important
    '';
}

```


## branches
### isabelle support
see branch isabelle

### old flake config without lazy
see branch pre-lazy

### before mapping *.lua.nix to *.lua in config
see branch before-map

### with old ./config dir
see branch has-old-config-dir

### old config without flakes (archived)
see branch legacy

# credits
- https://github.com/breuerfelix/feovim
