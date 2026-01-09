{
  description = "Obsidian to Anki";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        obsidian-to-anki = pkgs.writeShellScriptBin "obsidian-to-anki" ''
          export PYTHONPATH="${pkgs.python313Packages.markdown}/${pkgs.python313.sitePackages}:$PYTHONPATH"
          exec ${pkgs.python313}/bin/python3 ${./obsidian_to_anki.py} "$@"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [ ];
        };

        apps.obsidian-to-anki = {
          type = "app";
          program = "${obsidian-to-anki}/bin/obsidian-to-anki";
        };
      }
    );
}
