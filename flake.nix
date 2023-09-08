{
  description = "investbot flake";

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
      name = "investbot";
      packages = with pkgs; [
        nil
        alejandra
        clippy
        rustc
        rustup
        rustfmt
        rust-analyzer
      ];
    };
  };
}
