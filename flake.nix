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

      p01 = with pkgs;
        stdenv.mkDerivation {
          name = "01";
          src = ./challenges/01;
          buildPhase = ''
            mkdir -p $out/bin
            echo "cat $out/share/flag" > $out/bin/script
            chmod +x $out/bin/script
          '';
          installPhase = ''
            mkdir -p $out/share
            mv flag $out/share
          '';
        };
      p02 = with pkgs;
        stdenv.mkDerivation {
          name = "02";
          src = ./challenges/02;
          installPhase = ''
            mkdir -p $out/{share,bin}
            mv 02.hs $out/bin/
            mv flag $out/share/
          '';
        };
      p02wrapped = with pkgs;
        writeShellScript "thing" ''
          ${pkgs.ghc}/bin/runhaskell ${p02}/bin/02.hs ${p02}/share/flag
        '';
      p03 = with pkgs;
        stdenv.mkDerivation {
          name = "03";
          src = ./challenges/03;
          installPhase = ''
            mkdir -p $out/{share,bin}
            mv ende.py $out/bin/
            mv flag.txt.en $out/share/
            mv pw.txt $out/share/
          '';
        };

      p03wrapped = with pkgs;
        let python = python3.withPackages (ps: with ps; [ cryptography ]);
        in writeShellApplication {
          runtimeInputs = [ python ];
          name = "thing";
          text = ''
            ${python}/bin/python3 ${p03}/bin/ende.py -d ${p03}/share/flag.txt.en \
            "$(cat ${p03}/share/pw.txt)"
          '';
        };

      p04 = with pkgs;
        stdenv.mkDerivation {
          name = "studio-link";
          src = fetchurl {
            url =
              "https://mercury.picoctf.net/static/a14be2648c73e3cda5fc8490a2f476af/warm";
            sha256 = "sha256-LnAeguAgj5KlyzI94ZReipUP8UNKHqmCpdDWWUeMXD8=";
          };
          dontUnpack = true;
          nativeBuildInputs = [ autoPatchelfHook ];
          # wont work without autoPatchelfHook
          installPhase = ''
            install -D $src $out/bin/warm
            chmod a+x $out/bin/warm
          '';
        };

      p04wrapped = with pkgs;
        writeShellScript "thing" ''
          ${p04}/bin/warm -h
        '';

      p05 = with pkgs;
        haskell.packages.${compiler}.callPackage ./challenges/05/cabal.nix { };

    in {
      packages.${system} = { inherit p01 p02 p03 p03wrapped p04 p05; };
      apps.${system} = {
        p01 = {
          type = "app";
          program = "${p01}/bin/script";
        };
        p02 = with pkgs; {
          type = "app";
          program = "${p02wrapped}";
        };
        p03 = with pkgs; {
          type = "app";
          program = "${p03wrapped}/bin/thing";
        };
        p04 = with pkgs; {
          type = "app";
          program = "${p04wrapped}";
        };
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
        python = with pkgs;
          mkShell {
            buildInputs =
              [ (python3.withPackages (ps: with ps; [ cryptography ])) ];
          };
      };
    };
}
