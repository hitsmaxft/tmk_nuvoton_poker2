# However, if you want to override Niv's inputs, this will let you do that.
{ 
  pkgs? import <nixpkgs> {},
  dev? false
}:
with pkgs;
let

  # Builds the python env based on nix/pyproject.toml and
  # nix/poetry.lock Use the "poetry update --lock", "poetry add
  # --lock" etc. in the nix folder to adjust the contents of those
  # files if the requirements*.txt files change
in
mkShell {
  name = "tmk-poker-firmware";

  buildInputs = [ gcc-arm-embedded ]
    ++ lib.optional dev [
    dfu-programmer dfu-util diffutils git
      openocd
      sigrok-cli
    ]
    ;

  shellHook = ''
    # Prevent the avr-gcc wrapper from picking up host GCC flags
    # like -iframework, which is problematic on Darwin
    unset NIX_CFLAGS_COMPILE_FOR_TARGET
  '';
}
