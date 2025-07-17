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

	  displayManager.lightdm.enable = true;

	  windowManager.i3.enable = true;

	  xkb = {
		  layout = "us";
		  variant = "";
	  };
  };

  # Mounting support
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;  # optional but helpful for automount

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	  i3-gaps
	  i3status
	  dmenu
	  alacritty
	  xfce.thunar
	  udiskie             # automount in tray
	  pavucontrol         # audio control GUI
	  networkmanagerapplet
	  picom               # compositor
	  feh                 # wallpaper
	  lxappearance        # gtk theme manager
	  i3lock
	  xss-lock
	  libnotify
	  notify-osd
	  scrot
	  imagemagick


	  neovim
	  bat
	  signal-desktop
	  tmux
	  tmuxinator
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
	  ghostscript
	  foliate
  ];

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

  programs.i3lock.enable = true;
  security.pam.services.i3lock = {}; # ensures /etc/pam.d/i3lock is set up correctly



  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
