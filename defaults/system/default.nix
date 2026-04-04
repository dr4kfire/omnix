{
  config,
  pkgs,
  lib,
  ...
}: {
  # Example base system setting with a fallback default
  boot.loader.systemd-boot.enable = lib.mkDefault true;

  # Base packages all hosts get
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Other base system stuff...
}
