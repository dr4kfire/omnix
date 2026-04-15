{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config;
in {
  # ----------------------------------------------------------
  # HOST CONFIGURATION
  # Translates host options into actual NixOS settings
  # ----------------------------------------------------------
  config = {
    networking.hostName = cfg.host.hostname;
    time.timeZone = cfg.host.timeZone;
    i18n.defaultLocale = cfg.host.defaultLocale;
    i18n.supportedLocales = ["all"];

    # Allow unfree packages by default (most users expect this)
    nixpkgs.config.allowUnfree = true;

    # ----------------------------------------------------------
    # NIX SETTINGS
    # ----------------------------------------------------------
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };

    # ----------------------------------------------------------
    # SYSTEM PACKAGES
    # ----------------------------------------------------------
    environment.systemPackages = cfg.packages.systemPackages;

    # ----------------------------------------------------------
    # SHELL
    # ----------------------------------------------------------
    programs.${cfg.packages.shell}.enable = true;

    # ----------------------------------------------------------
    # BOOTLOADER
    # ----------------------------------------------------------
    boot.loader =
      {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      }
      // (lib.optionalAttrs (cfg.packages.bootloader == "grub") {
        grub = {
          enable = true;
          devices = ["nodev"];
          efiSupport = true;
          useOSProber = true;
        };
      })
      // (lib.optionalAttrs (cfg.packages.bootloader == "systemd-boot") {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
        };
      });

    # Note: "limine" bootloader is not available in standard NixOS.
    # It requires a custom package or out-of-tree module.
    # If limine is selected, a warning is issued and systemd-boot is used as fallback.
    warnings = lib.optional (cfg.packages.bootloader == "limine") ''
      The "limine" bootloader is not available in standard NixOS.
      Falling back to systemd-boot. If you need limine, provide a
      custom module at modules/system/bootloader/limine.nix.
    '';

    # ----------------------------------------------------------
    # DESKTOP ENVIRONMENT
    # ----------------------------------------------------------
    services.xserver =
      lib.mkIf (
        cfg.packages.desktopEnvironment
        != null
        || cfg.packages.displayManager != null
      ) {
        enable = true;

        displayManager =
          lib.optionalAttrs (
            cfg.packages.displayManager == "gdm"
          ) {
            gdm = {
              enable = true;
              wayland = cfg.packages.desktopEnvironment != "none";
            };
          }
          // lib.optionalAttrs (
            cfg.packages.displayManager == "sddm"
          ) {
            sddm = {
              enable = true;
              wayland.enable = cfg.packages.desktopEnvironment == "kde";
            };
          }
          // lib.optionalAttrs (
            cfg.packages.displayManager == "lightdm"
          ) {
            lightdm = {
              enable = true;
            };
          }
          // lib.optionalAttrs (
            cfg.packages.displayManager == "ly"
          ) {
            ly = {
              enable = true;
            };
          };

        desktopManager =
          lib.optionalAttrs (
            cfg.packages.desktopEnvironment == "gnome"
          ) {
            gnome = {
              enable = true;
            };
          }
          // lib.optionalAttrs (
            cfg.packages.desktopEnvironment == "kde"
          ) {
            plasma5 = {
              enable = true;
            };
          };
      };

    # Hyprland is a standalone window manager, not a desktopManager option
    programs.hyprland =
      lib.mkIf (
        cfg.packages.desktopEnvironment == "hyprland"
      ) {
        enable = true;
      };

    # ----------------------------------------------------------
    # AUDIO & HARDWARE
    # Enabled when a desktop environment is selected
    # ----------------------------------------------------------
    hardware = lib.mkIf (cfg.packages.desktopEnvironment != null) {
      opengl.enable = true;
    };

    security.rtkit.enable = lib.mkIf (cfg.packages.desktopEnvironment != null) true;
    services.pipewire = lib.mkIf (cfg.packages.desktopEnvironment != null) {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # ----------------------------------------------------------
    # USERS
    # ----------------------------------------------------------
    users.users =
      lib.mapAttrs (name: userCfg: {
        isNormalUser = true;
        description = userCfg.username;
        extraGroups = userCfg.groups;
        initialPassword =
          if userCfg.defaultPassword != ""
          then userCfg.defaultPassword
          else null;
        shell =
          if cfg.packages.shell == "zsh"
          then pkgs.zsh
          else if cfg.packages.shell == "fish"
          then pkgs.fish
          else if cfg.packages.shell == "nushell"
          then pkgs.nushell
          else pkgs.bash;
      })
      cfg.users;

    # ----------------------------------------------------------
    # HOME MANAGER (per-user)
    # ----------------------------------------------------------
    home-manager.users =
      lib.mapAttrs (name: userCfg: {pkgs, ...}: {
        home.username = userCfg.username;
        home.homeDirectory = "/home/${userCfg.username}";
        home.stateVersion = "25.11";

        programs.git = lib.mkIf (userCfg.git != {}) {
          enable = true;
          userName = userCfg.git.username;
          userEmail = userCfg.git.email;
        };

        # Set the user's shell via home-manager as well
        programs.${cfg.packages.shell}.enable = true;
      })
      cfg.users;

    # ----------------------------------------------------------
    # OMNIX AUTO-UPGRADE
    # ----------------------------------------------------------
    system.autoUpgrade = lib.mkIf cfg.omnix.autoUpgrade {
      enable = true;
      allowReboot = true;
      channel = "https://nixos.org/channels/nixos-${lib.versions.majorMinor lib.version}";
    };

    # ----------------------------------------------------------
    # OMNIX AUTO GARBAGE COLLECTOR
    # ----------------------------------------------------------
    nix.gc = lib.mkIf cfg.omnix.autoGarbageCollector {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
