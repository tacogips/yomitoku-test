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
        overlays = [
          (_: prev: {
            just = prev.just.overrideAttrs (_old: {
              version = "1.23.0";
            });
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; };

        python-with-packages = pkgs.python311.withPackages (pypkg: [
          pypkg.pip
        ]);
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

          buildInputs =
            (with pkgs; [
              nixfmt-rfc-style
              poetry
            ])
            ++ [ python-with-packages ];
        };
      }
    );
}
