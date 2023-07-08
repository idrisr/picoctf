{ mkDerivation, base, bytestring, lib, network, split }:
mkDerivation {
  pname = "x06";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base bytestring network split ];
  license = lib.licenses.mit;
  mainProgram = "x06";
}
