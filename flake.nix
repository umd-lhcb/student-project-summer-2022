{
  description = "Project for 2022 summer high school students.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    jupyterWith.url = "github:tweag/jupyterWith";
  };

  outputs = { self, nixpkgs, flake-utils, jupyterWith, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = nixpkgs.lib.attrValues jupyterWith.overlays;
        };
        iPython = pkgs.kernels.iPythonWith {
          name = "Python-env";
          packages = p: with p; [ numpy matplotlib uproot ];
        };
        jupyterEnvironment = pkgs.jupyterlabWith {
          kernels = [ iPython ];
          extraPackages = p: with p; [ root ];
        };
      in
      rec
      {
        devShell = jupyterEnvironment.env.overrideAttrs (oldAttrs: rec {
          name = "student-project-summer-2020";

          shellHook = oldAttrs.shellHook + ''
            # Filter out tensorflow and zfit warnings
            export TF_CPP_MIN_LOG_LEVEL=2
            export ZFIT_DISABLE_TF_WARNINGS=1

            # matplotlib gloabl config
            export MPLBACKEND=agg  # the backend w/o a UI
            export MPLCONFIGDIR=$(pwd)/.matplotlib

            # Prompt
            echo "This dev environment is prepared by nix."
            echo "Type 'jupyter-lab' to continue"
          '';

          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = with pkgs; [
              gyre-fonts
            ];
          };
        });
      });
}
