{
  description = "basegbot flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    lib = nixpkgs.lib;
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "basegbot-devenv";
      packages = with pkgs; [
        nil
        alejandra
        clippy
        rustc
        cargo
        rustup
        rustfmt
        rust-analyzer
        crate2nix
      ];
      RUST_BACKTRACE = 1;
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
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
