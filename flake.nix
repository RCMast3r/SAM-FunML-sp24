{
  description = "funml flake for training";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    utils.url = "github:numtide/flake-utils";
    segment_anything.url = "github:RCMast3r/segment_anything_flake";
  };
  outputs = { self, nixpkgs, segment_anything, utils,...}:
   utils.lib.eachSystem [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ] (system:
      let
        funml_training_overlay = final: prev: {
          funml_training = final.callPackage ./default.nix { };
        };
        weights_overlay = final: prev: {
          weights = final.callPackage ./weights.nix { };
        };
        clock_labels_overlay = final: prev: {
          clock_labels = final.callPackage ./clock_labels.nix { };
        };
        clock_samples_overlay = final: prev: {
          clock_samples = final.callPackage ./clock_samples.nix { };
        };
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
            # Include any other global Nixpkgs configuration here
          };
          overlays = [ clock_labels_overlay clock_samples_overlay funml_training_overlay weights_overlay segment_anything.overlays.default ];
        };

        shared_shell = pkgs.mkShell rec {
          name = "nix-devshell";
          packages = with pkgs; [
            funml_training
            weights
          ];

          shellHook = ''

            weights_path=${pkgs.weights}
            export WEIGHTS_PATH=$weights_path
            export PS1="\u${"f121"} \w (${name}) \$ "
          '';
        };

        clock_dataset_shell = pkgs.mkShell rec {
          name = "nix-devshell";
          packages = with pkgs; [
            funml_training
            weights
            clock_labels
            clock_samples
            cudatoolkit
            linuxPackages.nvidia_x11
            ncurses5
          ];

          shellHook = ''

            export CUDA_PATH=${pkgs.cudatoolkit}
            export LD_LIBRARY_PATH=/usr/lib/wsl/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib
            export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
            export EXTRA_CCFLAGS="-I/usr/include"

            weights_path=${pkgs.weights}
            clock_labels_path=${pkgs.clock_labels}
            clock_samples_path=${pkgs.clock_samples}
            export WEIGHTS_PATH=$weights_path
            export LABELS=$clock_labels_path
            export SAMPLES=$clock_samples_path
            export PS1="\u${"f121"} \w (${name}) \$ "
          '';
        };

      in
      {
        packages = rec {
          clock_labels = pkgs.clock_labels;
          clock_samples = pkgs.clock_samples;
          funml_training = pkgs.funml_training;
          default = funml_training;
        };

        devShells = {
          default = shared_shell;
          clock_dataset = clock_dataset_shell;
        };

      });

}
