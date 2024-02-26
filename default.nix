{ lib
, python311Packages
, segment_anything
}:

python311Packages.buildPythonApplication {
  pname = "predictor";
  version = "1.0.0";

  propagatedBuildInputs = [
    python311Packages.ipython
    python311Packages.matplotlib
    python311Packages.numpy
    python311Packages.opencv4
    python311Packages.openpyxl
    python311Packages.pillow
    python311Packages.torch
    python311Packages.torchvision
    segment_anything

  ];

  src = ./.;
}