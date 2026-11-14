{

  description = "yomitoku_test";

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
        overlays = [ (final: prev: { cudaPackages = final.cudaPackages_12; }) ];

        pkgs = import nixpkgs { inherit system overlays; };

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
              libGL
              cudatoolkit
              imagemagick
              glib
              pyright
              #              pkgs.linuxPackages.nvidia_x11
            ])
            ++ [ python-with-packages ];

          # TODO cuda is not available on linux not yet.
          # ref.
          # https://www.falconprogrammer.co.uk/blog/2024/03/nix-cuda-shellhook/
          shellHook = ''
                  echo "You are now using a NIX environment"
                  export CUDA_PATH=${pkgs.cudatoolkit}
                  export LD_LIBRARY_PATH="${
                    pkgs.lib.makeLibraryPath [
                      pkgs.cudatoolkit
                      pkgs.glib
                      pkgs.stdenv.cc.cc
                      pkgs.zlib
                      pkgs.libGL
                      # pkgs.linuxPackages.nvidia_x11
                    ]
                  }:$LD_LIBRARY_PATH"
                  export PATH="${python-with-packages}/bin:$PATH"
                  export PYTHONPATH="${python-with-packages}/${python-with-packages.sitePackages}:$PYTHONPATH"
            		# export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
              	export EXTRA_CCFLAGS="-I/usr/include"

          '';

        };
      }
    );
}
