{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.nur.url = "github:nix-community/NUR";
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
        system,
        inputs',
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.nur.overlay
          ];
        };
        overlayAttrs = {
          inherit (config.packages) default;
        };
        packages = rec {
          default = rofi-mum;
          rofi-mum = pkgs.callPackage (
            {
              writeShellApplication,
              nur,
              libnotify,
              gnused,
              gnugrep,
              rofi,
            }:
              writeShellApplication {
                name = "rofi-mum";

                runtimeInputs = [
                  nur.repos.lykos153.mum
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
