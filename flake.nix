{
  description = "Project for 2022 summer high school students.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    jupyterWith.url = "github:tweag/jupyterWith";
  };

  outputs = { self, nixpkgs, flake-utils, jupyterWith, ... }:
    {
      overlay = import ./nix/overlay.nix;
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ self.overlay ] ++ nixpkgs.lib.attrValues jupyterWith.overlays;
        };

        # Command line Python
        python = pkgs.python3;
        pythonPackages = python.pkgs;

        # Jupyter
        iPython = pkgs.kernels.iPythonWith {
          name = "Python-env";
          packages = p: with p; [ numpy matplotlib uproot mplhep ];
        };
        jupyterEnvironment = pkgs.jupyterlabWith {
          kernels = [ iPython ];
          extraPackages = p: with p; [ root ];
        };
      in
      {
        devShell = jupyterEnvironment.env.overrideAttrs (oldAttrs: rec {
          name = "student-project-summer-2022";

          buildInputs = oldAttrs.buildInputs ++ (with pythonPackages; [
            numpy
            matplotlib
            uproot
            mplhep
          ]);

          shellHook = oldAttrs.shellHook + ''
            # Filter out tensorflow and zfit warnings
            export TF_CPP_MIN_LOG_LEVEL=2
            export ZFIT_DISABLE_TF_WARNINGS=1

            # matplotlib gloabl config
            export MPLBACKEND=agg  # the backend w/o a UI
            export MPLCONFIGDIR=$(pwd)/.matplotlib

            # Unset Jupyter config dir
            unset JUPYTER_CONFIG_DIR
            # this is configured by ROOT and will cause problems

            # Prompt
            echo "This dev environment is prepared by nix."
            echo "Type 'jupyter lab' to continue"
          '';

          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = with pkgs; [
              gyre-fonts
            ];
          };
        });
      });
}
