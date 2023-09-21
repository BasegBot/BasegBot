_: {
  systemd.services.basegbot = {
    enable = true;
    wantedBy = [
      "multi-user.target"
    ];
    description = "basegbot";

    serviceConfig = {
      User = "root";
      ExecStart = "/nix/store/k13z1421f2h0b2lk14p6n7dnyv52d6mx-user-environment/bin/basegbot";
      Restart = "on-failure";
      RestartSec = 60;
    };
  };
}
