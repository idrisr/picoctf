{
  inputs.nixpkgs.url = "nixpkgs";
  description = "pico via haskell and flakes";
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
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
          buildInputs = [ ghc ];
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

    in {
      packages.${system} = {
        p01 = p01;
        p02 = p02;
      };
      apps.${system} = {
        p01 = {
          type = "app";
          program = "${p01}/bin/script";
        };
        p02 = with pkgs; {
          type = "app";
          program = "${p02wrapped}";
        };
      };
      devShells.${system}.default = with pkgs;
        mkShell { buildInputs = [ haskell-language-server ghc ]; };
    };
}
