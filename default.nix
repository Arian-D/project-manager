with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "ProjectManager";
  binaryName = "pm";
  buildInputs = [
    pkgs.sqlite
    (pkgs.ghc.withPackages (ps: with ps; [
      readline
      sqlite-simple
    ]))
  ];
  buildPhase = "make build";
  installPhase = ''
    install -D pm $out/bin/pm
  '';            
  src = ./.;
}
