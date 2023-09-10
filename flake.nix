{
  description = "basegbot flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
  };
  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "basegbot-devenv";
      packages = with pkgs; [
        nil
        alejandra
        clippy
        cargo
        rustc
        rustup
        rustfmt
        rust-analyzer
      ];
    };
  };
}
