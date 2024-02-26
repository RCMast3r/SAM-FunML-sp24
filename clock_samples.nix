{ lib, stdenv, fetchurl }:
# shoutout to this dude: https://nono.ma/download-dropbox-file-curl
stdenv.mkDerivation rec {
  name = "clock_samples";
  dontUnpack = true;
  dontFixup = true;
  src = fetchurl {
    url = "https://www.dropbox.com/scl/fi/t8wm1olh9s6bneneoo5o2/samples.npy?rlkey=vwoapbztkdnpg5prttfjotfv4&dl=1";
    curlOptsList = ["-L" ];
    sha256 = "sha256-J98mZicAE48xWy2a58rrWwXsqVEGQgVqrhYTGMK9I7o=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp ${src} $out/samples.npy
  '';

}