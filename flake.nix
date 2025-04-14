{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      systems = [
        "x86_64-linux"
      ];
      perSystem = {
        config,
        pkgs,
        ...
      }: {
        overlayAttrs = {
          inherit (config.packages) rofi-mum;
        };
        packages = rec {
          default = rofi-mum;
          rofi-mum = pkgs.callPackage (
            {
              writeShellApplication,
              libnotify,
              gnused,
              gnugrep,
              rofi,
              mum,
            }:
              writeShellApplication {
                name = "rofi-mum";

                runtimeInputs = [
                  mum
                  libnotify
                  gnused
                  gnugrep
                  rofi
                ];

                text = builtins.readFile ./rofi-mum;
              }
          ) {};
        };
        formatter = pkgs.alejandra;
      };
    };
}
