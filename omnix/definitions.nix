{lib, ...}: {
  # ----------------------------------------------------------
  # HOST OPTIONS
  # ----------------------------------------------------------
  options.host = {
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "The hostname of the system.";
    };

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "UTC";
      description = "The system time zone.";
    };

    defaultLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "The default system locale.";
    };

    system = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux";
      description = "The system architecture (e.g. x86_64-linux, aarch64-linux).";
    };
  };

  # ----------------------------------------------------------
  # USERS OPTIONS
  # ----------------------------------------------------------
  options.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({
      name,
      config,
      ...
    }: {
      options = {
        username = lib.mkOption {
          type = lib.types.str;
          description = "The login username for this user.";
        };

        defaultPassword = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "The initial password for this user (should be changed on first login).";
        };

        groups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = ["wheel"];
          description = "Additional groups for this user. 'wheel' is included by default for sudo access.";
        };

        keyboardLayout = lib.mkOption {
          type = lib.types.str;
          default = "us";
          description = "The keyboard layout for this user.";
        };

        git = lib.mkOption {
          type = lib.types.submodule {
            options = {
              username = lib.mkOption {
                type = lib.types.str;
                description = "The display name used in Git commits.";
              };

              email = lib.mkOption {
                type = lib.types.str;
                description = "The email address used in Git commits.";
              };
            };
          };
          default = {};
          description = "Git configuration for this user.";
        };
      };

      config.username = lib.mkDefault name;
    }));
    default = {};
    description = "Set of user accounts to create on the system.";
  };

  # ----------------------------------------------------------
  # PACKAGES OPTIONS
  # ----------------------------------------------------------
  options.packages = {
    systemPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "List of system packages to install.";
    };

    bootloader = lib.mkOption {
      type = lib.types.enum ["grub" "limine" "systemd-boot"];
      default = "systemd-boot";
      description = "The bootloader to use.";
    };

    displayManager = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum ["gdm" "sddm" "lightdm" "ly" "none"]);
      default = null;
      description = "The display manager to use. Set to null for headless systems.";
    };

    desktopEnvironment = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum ["gnome" "kde" "hyprland" "none"]);
      default = null;
      description = "The desktop environment or window manager to use.";
    };

    shell = lib.mkOption {
      type = lib.types.enum ["bash" "zsh" "fish" "nushell"];
      default = "bash";
      description = "The default shell for all users.";
    };
  };

  # ----------------------------------------------------------
  # OMNIX OPTIONS
  # ----------------------------------------------------------
  options.omnix = {
    autoUpgrade = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to automatically check for and apply system upgrades after each reboot.";
    };

    autoGarbageCollector = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to automatically run the garbage collector to remove unused packages.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional free-form configuration to pass through to the system.";
    };
  };
}
