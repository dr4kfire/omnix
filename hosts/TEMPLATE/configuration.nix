{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    host = {
      # ----------------------------------------------------------
      # PER-HOST SYSTEM CONFIGURATION
      # ----------------------------------------------------------
      hostname = "nixos";

      timeZone = "Europe/Warsaw";
      defaultLocale = "en_US.UTF-8";

      system = "x86_64-linux";
    };

    # ----------------------------------------------------------
    # USERS
    # ----------------------------------------------------------
    users = {
    };

    # ----------------------------------------------------------
    # SYSTEM PACKAGES
    # ----------------------------------------------------------
    packages = {
      systemPackages = with pkgs; [
        neovim
        vim
      ];

      bootloader = "limine";
      displayManager = "gdm";
      desktopEnvironment = "hyprland";

      shell = "zsh";
    };

    # ----------------------------------------------------------
    # OMNIX PER-HOST CONFIGURATION
    # ----------------------------------------------------------
    omnix = {
      # After each reboot checks for avaliable upgrades and asks
      # if you want to update them
      autoUpgrade = false;
      # Deletes unnecessary packages that are not included in
      # config
      autoGarbageColletor = true;
    };
  };

  # Put any additional config here
}
