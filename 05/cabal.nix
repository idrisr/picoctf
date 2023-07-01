{ mkDerivation, base, base64, exiftool, lib, text }:
mkDerivation {
  pname = "x05";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base base64 exiftool text ];
  license = lib.licenses.mit;
  mainProgram = "x05";
}
