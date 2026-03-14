{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

# Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Loading NVIDIA modules early ensures Wayland starts correctly on your 4060
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  networking.hostName = "nixos"; # Define your hostname.

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

  services.greetd = {
	  enable = true;
	  settings = {
		  default_session = {
			  command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
			  user = "britz";
		  };
	  };
  };

# Mounting support
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;
  services.tumbler.enable = true;
  services.udev.packages = with pkgs; [ zsa-udev-rules ];

# Polkit for mount permissions
  security.polkit.enable = true;

# Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };

# Enable Graphics
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
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

# User account
  users.users.britz = {
    isNormalUser = true;
    description = "Johnathon Britz";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  programs.firefox.enable = true;
  programs.dconf.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-volman
    thunar-archive-plugin
  ];

  programs.hyprland = {
  	enable = true;
	withUWSM = true;
	xwayland.enable = true;
  };

  programs.hyprlock.enable = true;

  # Environment variables for NVIDIA and Electron/Wayland compatibility 
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
      # Wayland-native replacements for your i3 tools [cite: 14]
      waybar       # Status bar
      wofi         # Launcher
      hyprpaper    # Wallpaper
      hyprlock     # Screen locker
      grim         # Screenshots
      slurp        # Region selection
      wl-clipboard # Clipboard support
      hypridle
      kitty

      # moder wayland utilities
      yazi
      cliphist
      swaynotificationcenter
 

      # Core Utilities from your old config [cite: 15, 16]
      alacritty
      udiskie
      pavucontrol
      networkmanagerapplet
      libnotify
      polkit_gnome
      
      # Your Applications [cite: 55, 56, 57]
      bat blender chromium ffmpeg fzf gcc ghostscript 
      git kdePackages.kdenlive keymapp lua5_1 luarocks nodejs_24
      obsidian obsidian-export pandoc podman python312 qpdf ripgrep
      signal-desktop tmux unzip vlc zoom-us zoxide neovim p7zip
      libreoffice obs-studio gromit-mpx
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      dejavu_fonts fira font-awesome ibm-plex open-sans source-han-sans
      nerd-fonts.fira-code nerd-fonts.jetbrains-mono
    ];
  };

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" "Fira Code Nerd Font" ];
  };

  services.openssh.enable = true;
  services.dbus.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  system.stateVersion = "24.11";
}
