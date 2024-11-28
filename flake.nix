{

  description = "yomitoku-test";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      pre-commit-hooks,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        python-with-packages = pkgs.python312.withPackages (pypkg: [ pypkg.pip ]);
      in
      {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt-rfc-style.enable = true;
              statix.enable = true;
              deadnix.enable = true;
            };
          };
        };

        formatter = pkgs.nixfmt-rfc-style;
        devShells.default = pkgs.mkShell {
          shellHook = ''
            echo "You are now using a NIX environment"
            export CUDA_PATH=${pkgs.cudatoolkit}
          '';

          buildInputs =
            (with pkgs; [
              nixfmt-rfc-style
              poetry
              cudaPackages_12.cudatoolkit
            ])
            ++ [ python-with-packages ];
        };
      }
    );
}
