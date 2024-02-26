{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sam_vit_h_4b8939";
  dontUnpack = true;
  dontFixup = true;
  src = fetchurl {
    url = "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth";
    sha256 = "sha256-p787AvPr8SZ6upE/9jfZotXDPTFzu2eeRtnzOMJvJi4=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp ${src} $out/sam_vit_h_4b8939.pth
  '';


}