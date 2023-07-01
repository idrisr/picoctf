{ mkDerivation, base, base64, exiftool, lib, text }:
mkDerivation {
  pname = "x05";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base exiftool ];
  executableHaskellDepends = [ base base64 exiftool text ];
  testHaskellDepends = [ base ];
  license = lib.licenses.mit;
  mainProgram = "x05";
}
