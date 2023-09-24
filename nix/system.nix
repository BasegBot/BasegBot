{
  pkgs,
  lib,
  ...
}: let
  cargo_nix = pkgs.callPackage ../Cargo.nix {};
  basegbot = cargo_nix.rootCrate.build;
in {
  imports = [
    ./hw-config.nix
    ./security.nix
    ./service.nix
  ];

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };

  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";
      configurationLimit = 10;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "basegbot";

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  services.tailscale.enable = true;
  services.fstrim.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = lib.mkForce "no";
      PasswordAuthentication = lib.mkForce "false";
      PubkeyAuthentication = lib.mkForce "true";
    };
  };

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
  };

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  users = {
    defaultUserShell = pkgs.nushell;
    users.basegbot = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFgkIK+VR+xpAL85buL9ocql82kcVCcHbZyaytVDYB6 basegbot"
      ];
      isNormalUser = true;
      description = "basegbot";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
        basegbot
        git
        helix
        lazygit
        croc
      ];
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      extra-experimental-features = ["flakes" "nix-command"];
      auto-optimise-store = true;
      builders-use-substitutes = true;
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

  system.autoUpgrade.enable = false;
  system.stateVersion = "23.05";
}
