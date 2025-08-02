# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];

# Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
    networking.networkmanager.enable = true;

# Set your time zone.
  time.timeZone = "America/Los_Angeles";

# Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.displayManager.defaultSession = "none+i3";
  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
    };


    windowManager = {
      i3 = {
        enable = true;

        extraPackages = with pkgs; [
          i3-gaps
            dmenu
            i3status
            i3lock
            i3blocks
            picom # compositor for transparency /shadows
            feh # wallpaper setting
            xterm
            alacritty
            scrot
            imagemagick
            udiskie     # automount in tray
            pavucontrol # audio control gui
            networkmanagerapplet
            lxappearance #gtk theme manager
            xss-lock
            libnotify
            notify-osd
            xfce.thunar
            polkit
            polkit_gnome
            ];
      };
    };

# Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };


  };

# Mounting support
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;  # optional but helpful for automount
  services.tumbler.enable = true;
  services.udev.packages = with pkgs; [
    zsa-udev-rules
  ];

# Polkit for mount permissions
  security.polkit.enable = true;

# Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };

# Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

# Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

# Modesetting is required.
    modesetting.enable = true;

# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
# Enable this if you have graphical corruption issues or application crashes after waking
# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
# of just the bare essentials.
    powerManagement.enable = false;

# Fine-grained power management. Turns off GPU when not in use.
# Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

# Use the NVidia open source kernel module (not to be confused with the
# independent third-party "nouveau" open source driver).
# Support is limited to the Turing and later architectures. Full list of 
# supported GPUs is at: 
# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
# Only available from driver 515.43.04+
    open = false;

# Enable the Nvidia settings menu,
# accessible via `nvidia-settings`.
    nvidiaSettings = true;

# Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

# Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
# If you want to use JACK applications, uncomment this
#jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
  };

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Screen locker setup
  systemd.user.services.xss-lock = {
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.xss-lock}/bin/xss-lock -- ${pkgs.i3lock}/bin/i3lock -c 000000";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "Polkit GNOME Auth Agent";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Type = "simple";
      Restart = "on-failure";
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.udisks2.filesystem-mount" ||
              action.id == "org.freedesktop.udisks2.filesystem-mount-system") &&
            subject.isInGroup("wheel")) {
        return polkit.Result.YES;
        }
        });
  '';


# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.britz = {
    isNormalUser = true;
    description = "Johnathon Britz";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
#  thunderbird
    ];
  };

# Install firefox.
  programs.firefox.enable = true;
  programs.dconf.enable = true;


  programs.xfconf.enable = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-volman
      thunar-archive-plugin  # optional but useful
  ];

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
      bat
      signal-desktop
      tmux
      gparted
      obsidian
      podman
      git
      gcc
      lua5_1
      luarocks
      python312
      python312Packages.pip
      unzip
      typescript
      nodejs_24
      ripgrep
      keymapp
      pandoc
      texlive.combined.scheme-medium
      ghostscript
      zoxide
      fzf
      ];

  fonts = {
    enableDefaultPackages = true;  # keep standard Unicode coverage
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
      ];
  };


# (Optional) Configure default monospace fonts for fontconfig:
  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" "Fira Code Nerd Font" ];
  };


# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.dbus.enable = true;


# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;


# printing stuff
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };



# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
