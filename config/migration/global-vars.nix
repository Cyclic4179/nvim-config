{
  pkgs,
  lib,
  inputs,
}:

{
  JAVA_SE_17 = "${pkgs.jdk17}/lib/openjdk";
  # https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
  ECLIPSE_JAVA_GOOGLE_STYLE = "${inputs.google-styleguide}/eclipse-java-google-style.xml";
  VSCODE_JAVA_DEBUG_PATH = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
  #VSCODE_JAVA_TEST_PATH = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test";
  # wait until at least vscode-java-test 0.41 is out (https://github.com/microsoft/vscode-java-test/issues/1681)
  VSCODE_JAVA_TEST_PATH =
    let
      vscode-java-test =
        with pkgs;
        vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vscode-java-test";
            publisher = "vscjava";
            version = "0.42.2024080106";
            hash = "sha256-bg6ckBp8VJwXDp877wqt4MAyBPNJZWog/aEptbSaPg4=";
          };
          meta = {
            license = lib.licenses.mit;
          };
        };
    in
    "${vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test";
  # Link together all treesitter grammars into single derivation
  # for some reason we need to do this
  TREESITTER_PARSER_PATH = (
    pkgs.symlinkJoin {
      name = "nix-treesitter-parsers";
      paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    }
  );
}
