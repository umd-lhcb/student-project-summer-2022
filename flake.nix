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
        };
      in rec
      {
        apps.jupyterlab = {
          type = "app";
          program = "${jupyterEnvironment}/bin/jupyter-lab";
        };
        defaultApp = apps.jupyterlab;
        devShell = jupyterEnvironment.env;
      });
}
