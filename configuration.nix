# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  hardware.graphics = {
   enable = true;
   enable32Bit = true;
  };
	  
  #boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.amdgpu.initrd.enable = true; # sets boot.initrd.kernelModules = ["amdgpu"];

 # hardware.graphics.extraPackages = with pkgs; [
 #  amdvlk
 # ];
  # For 32 bit applications 
 # hardware.graphics.extraPackages32 = with pkgs; [
 #   driversi686Linux.amdvlk
 # ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.niri.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
  
  #Enable fatpak
  services.flatpak.enable = true;

  #Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."jhanner" = {
    isNormalUser = true;
    description = "Jhanner";
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #Kde Apps
      kdePackages.kate
      kdePackages.merkuro
      kdePackages.marknote
      kdePackages.kcalc
      kdePackages.kasts
      kdePackages.kdenlive
      kdePackages.francis
      kdePackages.kclock
      kdePackages.kweather
      haruna
      #end
      podman-compose
      strawberry
      blender
      vscodium
      fastfetch
      wayland-utils
      #appimage-run
      gimp
      krita
      heroic
      lutris
      godot_4_7
      protontricks
      vulkan-tools
      github-desktop
      libreoffice
      #libresprite
      lmms-full
      qbittorrent
      noctalia
      waybar
      alacritty
      kitty
      #obs
      obs-studio
      obs-studio-plugins.obs-pipewire-audio-capture
      obs-studio-plugins.obs-move-transition
      obs-studio-plugins.obs-scene-as-transition
      obs-studio-plugins.obs-vkcapture
      #end
      #Programming Languages
      lua5_4
      love
      typescript
      go
      rustup
      python3
      dotnet-sdk
      #end
    ];
  };

  #Enable steam
  programs.steam = {
    enable = true; # Master switch, already covered in installation
    remotePlay.openFirewall = true;  # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
    # Other general flags if available can be set here.
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  #Enable appimage
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override 
  {
    extraPkgs = pkgs: 
    [
      pkgs.icu
      pkgs.libxcrypt-legacy
      pkgs.python312
    ]; 
  };

  #Enable gamemode
  #programs.gamemode.enable = true;

  #Install require fonts
  fonts.packages = with pkgs; [
	  nerd-fonts.adwaita-mono
	  noto-fonts
	  noto-fonts-cjk-sans
	  noto-fonts-color-emoji
	  liberation_ttf
	  cantarell-fonts
	  poppins
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
  ];

  #environment.sessionVariables = {
  #  AMD_VULKAN_ICD = "RADV";
  #  MESA_SHADER_CACHE_MAX_SIZE = "12G";
  #};

  # nix management automations
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    allowReboot = false;  # Set to true if you want automatic reboots
    #flake = inputs.self.outPath;
  };

  zramSwap.enable = true;

  #enable podman
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
     neovim
     wget
     curl
     htop
     emacs-nox
     ripgrep
     fzf
     fd
     git
     unrar
     gvfs
     fuse
     fuse3
     (pkgs.ffmpeg-full.override { withUnfree = true; })
     android-tools
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
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
