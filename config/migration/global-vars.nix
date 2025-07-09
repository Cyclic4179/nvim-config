{
  pkgs,
  lib,
  inputs,
}:

# use like vim.g.MY_VAR

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
  JULIA_WITH_LS_PATH = lib.getExe (pkgs.julia.withPackages [ "LanguageServer" ]);
  JULIA_LS_START_FILE =
    builtins.toFile "StartLanguageServer.jl" # julia
      ''
        using LanguageServer

        depot_path = get(ENV, "JULIA_DEPOT_PATH", "")

        project_path = let
            dirname(something(
                ## 1. Finds an explicitly set project (JULIA_PROJECT)
                Base.load_path_expand((
                    p = get(ENV, "JULIA_PROJECT", nothing);
                    p === nothing ? nothing : isempty(p) ? nothing : p
                )),
                ## 2. Look for a Project.toml file in the current working directory,
                ##    or parent directories, with $HOME as an upper boundary
                Base.current_project(),
                ## 3. First entry in the load path
                get(Base.load_path(), 1, nothing),
                ## 4. Fallback to default global environment,
                ##    this is more or less unreachable
                Base.load_path_expand("@v#.#"),
            ))
        end

        @info "Running language server" VERSION pwd() project_path depot_path

        server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
        server.runlinter = true
        run(server)
      '';
}
