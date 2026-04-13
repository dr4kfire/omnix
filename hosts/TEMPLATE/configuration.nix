{
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  config.host = {
    # lowercase name of this host
    hostname = "nixos";

    timeZone = "Europe/Warsaw";
    defaultLocale = "en_US.UTF-8";

    # the processor architecture followed by '-linux'
    system = "x86_64-linux";
    bootloader = "limine"; # options: [ limine, grub ]
  };

  config.omnix = {
    # After each reboot checks for avaliable upgrades and asks
    # if you want to update them
    autoUpgrade = false;
    # Deletes unnecessary packages that are not included in config
    autoGarbageColletor = true;
  };

  # Put any additional config here
}
