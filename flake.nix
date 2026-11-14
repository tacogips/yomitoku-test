{

  description = "yomitoku_test";

  inputs = {
    nixpkgs.url = "github:tacogips/nixpkgs-security/d2a93d2fe7820d90eaa10af53891412ec3614f56";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  # Share the patched Node.js and CA bundle across transitive development inputs.
  inputs.pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  inputs.pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";

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
        overlays = [ (final: prev: { cudaPackages = final.cudaPackages_12; }) ];

        pkgs = import nixpkgs { inherit system overlays; };

        linuxLibraries = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          pkgs.cudatoolkit
          pkgs.libGL
        ];

        python-with-packages = pkgs.python312.withPackages (pypkg: [
          pypkg.pip
          #pypkg.torchWithCuda
          # ^^^ result in stacking during install
          #[1/1/8 built] building cudnn-8.9.7.29 (unpackPhase): unpacking source archive /nix/store/2m4cq2z7dv41bylagmkq47lbybqfzy61-cudnn-linux-x86_64-8.9.7.29_cuda12-archive.tar[1/2[1/2/8 built] building magma-2.7.2 (buildPhase): nvcc warning : incompatible redefinition for option 'compiler-bindir', the last value of this option was used
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
              just
              taplo

              stdenv.cc.cc.lib
              zlib
              imagemagick
              glib
              pyright
              #              pkgs.linuxPackages.nvidia_x11
            ])
            ++ linuxLibraries
            ++ [ python-with-packages ];

          # TODO cuda is not available on linux not yet.
          # ref.
          # https://www.falconprogrammer.co.uk/blog/2024/03/nix-cuda-shellhook/
          shellHook = ''
                  echo "You are now using a NIX environment"
                  ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''export CUDA_PATH=${pkgs.cudatoolkit}''}
                  export LD_LIBRARY_PATH="${
                    pkgs.lib.makeLibraryPath ([

                      pkgs.glib
                      pkgs.stdenv.cc.cc
                      pkgs.zlib
                      # pkgs.linuxPackages.nvidia_x11
                    ] ++ linuxLibraries)
                  }:$LD_LIBRARY_PATH"
                  export PATH="${python-with-packages}/bin:$PATH"
                  export PYTHONPATH="${python-with-packages}/${python-with-packages.sitePackages}:$PYTHONPATH"
              	export EXTRA_CCFLAGS="-I/usr/include"

          '';

        };
      }
    );
}
