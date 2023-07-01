{
  inputs.nixpkgs.url = "nixpkgs";
  description = "pico via haskell and flakes";
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      compiler = "ghc928";
      pkgs = import nixpkgs { inherit system; };
      hpkgs = pkgs.haskell.packages."${compiler}";
      haskellDevTools = with hpkgs; [
        ghc
        ghcid
        fourmolu
        haskell-language-server
        implicit-hie
        cabal-install
        pkgs.zlib
      ];

      p05 = with pkgs;
        haskell.packages.${compiler}.callPackage ./05/cabal.nix { };

    in {
      packages.${system} = { inherit p05; };
      apps.${system} = {
        p05 = with pkgs; {
          type = "app";
          program = "${p05}/bin/x05";
        };
      };

      devShells.${system} = {
        haskell = with pkgs;
          mkShell {
            buildInputs = haskellDevTools ++ [ exiftool ];
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath haskellDevTools;
            shellHook = ''
              alias v=vim
            '';
          };
      };
    };
}
