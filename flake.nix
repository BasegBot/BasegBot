{
  description = "basegbot flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fenix.url = "github:nix-community/fenix/monthly";
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    fenix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlays = [fenix.overlays.default];
    pkgs = import nixpkgs {
      inherit system overlays;
    };
    lib = nixpkgs.lib;
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "basegbot-devenv";
      packages = with pkgs; [
        nil
        alejandra
        rust-analyzer-nightly
        crate2nix
        (fenix.packages.${system}.complete.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
      ];
      RUST_BACKTRACE = 1;
      RUST_SRC_PATH = "${fenix.packages.${system}.complete.rust-src}/lib/rustlib/src/rust/library";
    };
    nixosConfigurations = {
      basegbot = lib.nixosSystem {
        inherit system;
        modules = [
          ./nix/system.nix
          inputs.nh.nixosModules.default
        ];
      };
    };
  };
}
