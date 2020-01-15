with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "ProjectManager";
  binaryName = "pm";
  buildInputs = [
    (pkgs.ghc.withPackages (ps: with ps; [
      readline
    ]))
  ];
  buildPhase = "make build";

  installPhase = ''
    install -D pm $out/bin/pm
  '';            
  src = ./.;
  
}
