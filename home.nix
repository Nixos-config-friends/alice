# Home Manager pour le compte de Marie.
# Rappel : ce qui est déclaré ici est réimposé à chaque mise à jour, et les
# fichiers gérés deviennent en lecture seule. N'y mettre que ce qu'on veut figer.
{ ... }:
{
  # Version au moment de l'INSTALLATION. Ne jamais la changer ensuite.
  home.stateVersion = "26.05";

  # Applis Flathub installées d'office pour elle (en plus de celles qu'elle
  # installe elle-même dans « Logiciels », qui ne sont jamais supprimées).
  # services.flatpak.packages = [ "org.kde.krita" ];
}
