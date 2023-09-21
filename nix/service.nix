_: {
  systemd.services.basegbot = {
    enable = true;
    wantedBy = [
      "multi-user.target"
    ];
    description = "basegbot";

    serviceConfig = {
      User = "root";
      ExecStart = "/etc/profiles/per-user/basegbot/bin/basegbot";
      Restart = "on-failure";
      RestartSec = 60;
    };
  };
}
