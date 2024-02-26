{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "clock_labels";
  dontUnpack = true;
  dontFixup = true;
  src = fetchurl {
    url = "https://www.dropbox.com/scl/fi/e3ba61msz2n3wt0ubo28a/labels.npy?rlkey=obvdp2pkjgkoieqrj0ztdg1sd&dl=1";
    curlOptsList = ["-L" ];
    sha256 = "sha256-A6u6Kl/OdUCIAMA770/ZimcN7zVg1N4j9ydoF9LSmX0=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp ${src} $out/labels.npy
  '';

}