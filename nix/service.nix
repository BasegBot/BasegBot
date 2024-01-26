{pkgs, ...}: let
  cargo_nix = pkgs.callPackage ../Cargo.nix {};
  basegbot = cargo_nix.rootCrate.build;
in {
  systemd.services.basegbot = {
    enable = true;
    wantedBy = [
      "multi-user.target"
    ];
    description = "basegbot";

    serviceConfig = {
      User = "root";
      ExecStart = "${basegbot}/bin/basegbot";
      Restart = "on-failure";
      RestartSec = 60;
    };
  };
}
