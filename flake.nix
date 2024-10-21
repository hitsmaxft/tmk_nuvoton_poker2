{
  description = "A Nix-flake-based C/C++ development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.05";

  outputs = { self, nixpkgs }:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
      pkgs = import nixpkgs { inherit system; };
    });
  in
  {
    devShells = forEachSupportedSystem ({ pkgs, dev? false }: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          gcc-arm-embedded 
          dfu-programmer dfu-util diffutils git
          openocd
          sigrok-cli
        ];
      };
      build = pkgs.mkShell {
        packages = with pkgs; [
          gcc-arm-embedded 
        ];
      };
    });
  };
}
