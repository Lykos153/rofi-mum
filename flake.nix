{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.nur.url = "github:nix-community/NUR";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {self, nixpkgs, flake-utils, nur, ...}@inputs: 
  let
    recipe =  { writeShellApplication, pkgs }:

      writeShellApplication rec {
        name = "rofi-mum";

        runtimeInputs = [
          pkgs.nur.repos.lykos153.mum
          pkgs.libnotify
          pkgs.gnused
          pkgs.gnugrep
          pkgs.rofi
        ];

        text = builtins.readFile ./rofi-mum;
      };
  in
  flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
        inherit system;
        overlays = [ nur.overlay ];
    };
  in {
    defaultPackage = pkgs.callPackage recipe {};
  });
}
