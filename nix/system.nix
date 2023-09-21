{pkgs, ...}: let
  cargo_nix = pkgs.callPackage ../Cargo.nix {};
  basegbot = cargo_nix.rootCrate.build;
in {
  imports = [
    ./hw-config.nix
    ./security.nix
    ./service.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "basegbot";

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  programs.direnv.enable = true;
  programs.direnv.loadInNixShell = true;
  programs.direnv.nix-direnv.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  users = {
    users.basegbot = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFgkIK+VR+xpAL85buL9ocql82kcVCcHbZyaytVDYB6 basegbot"
      ];
      isNormalUser = true;
      description = "basegbot";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
        git
        helix
        lazygit
        croc
        basegbot
      ];
    };
  };

  nix = {
    settings = {
      extra-experimental-features = ["flakes" "nix-command"];
      auto-optimise-store = true;
      builders-use-substitutes = true;
      keep-derivations = true;
      keep-outputs = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
      substituters = [
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05";
}
