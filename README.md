# student-project-summer-2022
Project for 2022 summer high school students.


## Installation

### Linux

1. Install `nix`:

    ```
    $ sh <(curl -L https://nixos.org/nix/install) --daemon
    ```

2. Adding the following lines to `/etc/nix/nix.conf` with `sudo` permission:

    ```
    experimental-features = nix-command flakes
    ```

3. In the project root directory, type `nix develop`

    Wait until the process is finished. Now the Jupyter notebook can be launched via:

### macOS and Microsoft Windows

1. First, install `anaconda`
2. Create an isolated environment:

    ```
    conda create -n student-project-summer-2022
    ```
3. Install dependencies:

    ```
    conda install -n student-project-summer-2022 -c conda-forge numpy matplotlib uproot mplhep zfit
    ```

4. Enter the specified conda environment:

    ```
    conda activate student-project-summer-2022
    ```


## Usage

Invoke `jupyter` with the following command

```
jupyter lab
```
