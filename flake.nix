{
  description = "Project for 2022 summer high school students.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          # overlays = [];
        };
        python = pkgs.python3;
        pythonPackages = python.pkgs;
      in
      {
        devShell = pkgs.mkShell {
          name = "student-project-summer-2022";
          buildInputs = with pythonPackages; [
            pkgs.root

            # Python requirements (pin as much as possible)
            numpy
            matplotlib
            uproot
            jupyter
          ];

          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = with pkgs; [
              gyre-fonts
            ];
          };

          shellHook = ''
            # Filter out tensorflow and zfit warnings
            export TF_CPP_MIN_LOG_LEVEL=2
            export ZFIT_DISABLE_TF_WARNINGS=1

            # matplotlib gloabl config
            export MPLBACKEND=agg  # the backend w/o a UI
            export MPLCONFIGDIR=$(pwd)/.matplotlib
          '';
        };
      });
}
