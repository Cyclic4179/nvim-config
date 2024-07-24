let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommandLocal "my-example" { } ''
  echo My example command is running

  mkdir $out

  env

  ${pkgs.lib.getExe pkgs.tree} / -L 2

  echo I can write data to the Nix store > $out/message

  echo I can also run basic commands like:

  echo ls
  ls

  echo whoami
  whoami

  echo date
  date
''
