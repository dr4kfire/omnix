{config, ...}: {
  imports = [
    # You should leave these as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Do not touch this
  system.stateVersion = "24.05";
}
