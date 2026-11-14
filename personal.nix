# Tout ce qui est propre à Alice et à son MacBook.
{ config, pkgs, ... }:
{
  relatives = {
    user = "alice";
    fullName = "Alice";
    flake = "github:Nixos-config-friends/alice";

    # Compte administrateur local, pour intervenir sur place si besoin.
    # Aucun accès à distance n'est possible (pas de serveur SSH).
    # Mettre null pour ne pas le créer.
    admin = "depannage";

    gnome.buttons = "mac";

    hardware.oldMac = {
      enable = true; # Wi-Fi Broadcom, ventilateurs, clavier Apple FR
      webcam = false; # passer à true si elle fait des visios, puis tester
      swapCtrlCmd = false; # true pour garder ⌘C / ⌘V : à essayer avec elle
    };

    autoUpgrade = {
      time = "12:30";
      # Créer ce fichier sur la machine (voir README), sinon mettre null.
      pingUrlFile = "/etc/nixos-secrets/healthchecks-url";
    };

    backup = {
      enable = false; # passer à true une fois la Storage Box prête (voir README)
      # Chemin relatif = dans le dossier personnel de la Storage Box.
      repository = "sftp:uXXXXXX@uXXXXXX.your-storagebox.de:sauvegardes/macbook-alice";
    };
  };

  # Hetzner Storage Box : SSH sur le port 23.
  programs.ssh.extraConfig = ''
    Host *.your-storagebox.de
      Port 23
  '';

  # Ses applis en plus de celles du socle
  environment.systemPackages = with pkgs; [
    krita
    inkscape
    gimp
  ];

  home-manager.users.${config.relatives.user} = import ./home.nix;

  # Version de NixOS au moment de l'INSTALLATION. Ne jamais la changer ensuite,
  # même en passant à une nouvelle version de NixOS.
  system.stateVersion = "26.05";
}
