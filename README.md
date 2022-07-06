# student-project-summer-2022
Project for 2022 summer high school students.


## Installation

Make sure you have cloned the project via the `git` (SSH) protocol.

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

    Wait until the process is finished.

### macOS and Microsoft Windows

1. Install `anaconda`

2. Create an isolated environment and install dependencies:

    ```
    conda env create -f environment.yml
    ```

3. Enter the specified conda environment:

    ```
    conda activate student-project-summer-2022
    ```


## Usage

Invoke `jupyter` with the following command:

```
jupyter lab
```
