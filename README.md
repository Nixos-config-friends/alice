# nixos-marie

Configuration NixOS du MacBook Air (13 pouces, 2017) de Marie.
Elle s'appuie sur le socle [`nixos-proches`](https://github.com/VOTRE-COMPTE/nixos-proches)
et ne contient que ce qui lui est propre.

**Comment ça marche** : personne ne se connecte au MacBook. Chaque jour vers
12 h 30 (sur secteur), il vient lire ce dépôt et applique la configuration.
Chaque lundi, l'Action GitHub passe à la dernière version du socle, construit
toute la machine, et ne publie la nouvelle version que si la construction réussit.
Tout changement est daté dans l'historique de ce dépôt.

## Avant de commencer

- Remplacer `VOTRE-COMPTE` dans `flake.nix`, `personal.nix` et ce README.
- Le dépôt doit être **public** (le MacBook le lit sans identifiant ; aucun secret n'y est stocké).
- Préparer :
  - une clé USB avec l'image graphique de NixOS (GNOME) ;
  - **un adaptateur USB-Ethernet ou le partage de connexion USB d'un téléphone Android** :
    le Wi-Fi ne fonctionne pas tant que le pilote n'est pas installé ;
  - de préférence, une petite clé Wi-Fi USB à pilote libre, en secours.
- Copier ses fichiers personnels sur une clé (photos, documents, dessins — pas d'applications).

## Installation

1. Démarrer sur la clé : maintenir **Option (⌥)** à l'allumage, choisir « EFI Boot ».
2. Brancher l'Ethernet ou le partage de connexion.
3. Dans l'installeur :
   - langue français, clavier **Français (Macintosh)** ;
   - effacer le disque, **cocher le chiffrement** : c'est Marie qui tape la phrase
     de passe du disque (elle la retapera à chaque démarrage) ;
   - créer le compte **`depannage`** (le compte administrateur, avec votre mot de passe).
     Le compte `marie` sera créé par la configuration.
4. Redémarrer, se connecter en `depannage`, puis :
   ```sh
   nix-shell -p git
   git clone https://github.com/VOTRE-COMPTE/nixos-marie && cd nixos-marie
   cp /etc/nixos/hardware-configuration.nix .     # remplace l'exemple
   git add hardware-configuration.nix              # un flake ne voit que les fichiers suivis par git
   sudo env NIX_CONFIG="experimental-features = nix-command flakes" \
     nixos-rebuild switch --flake .#macbook-marie
   ```
5. Faire choisir son mot de passe à Marie (c'est elle qui le tape) :
   ```sh
   sudo passwd marie
   ```
6. Publier le vrai `hardware-configuration.nix` et le `flake.lock` sur GitHub
   (depuis le MacBook avec un jeton, ou en copiant les deux fichiers sur votre machine).
   **Tant que ce n'est pas fait, la mise à jour automatique échouera.**

## Secrets (sur la machine, jamais dans le dépôt)

```sh
sudo install -d -m 700 /etc/nixos-secrets
```

- **healthchecks.io** : créer un check (période 1 jour, délai de grâce 3 jours,
  car la mise à jour est sautée sur batterie), puis :
  ```sh
  echo "https://hc-ping.com/VOTRE-UUID" | sudo tee /etc/nixos-secrets/healthchecks-url
  sudo chmod 600 /etc/nixos-secrets/healthchecks-url
  ```
  Sans ce fichier, mettre `autoUpgrade.pingUrlFile = null;` dans `personal.nix`.

- **Sauvegarde restic** (quand vous l'activez dans `personal.nix`) :
  ```sh
  # Mot de passe du dépôt restic : à garder aussi dans votre gestionnaire de mots de passe
  sudo sh -c 'umask 077; head -c 32 /dev/urandom | base64 > /etc/nixos-secrets/restic-password'
  # Clé SSH de root pour la Storage Box Hetzner
  sudo ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519
  sudo ssh-copy-id -p 23 -s uXXXXXX@uXXXXXX.your-storagebox.de
  sudo ssh -p 23 uXXXXXX@uXXXXXX.your-storagebox.de ls   # accepter l'empreinte du serveur
  ```
  Rappel : avec ce mot de passe, vous pouvez lire ce qui est sauvegardé hors du coffre.
  Le coffre Cryptomator, lui, reste chiffré avec le mot de passe de Marie.

## Avec Marie

- **Cryptomator** : c'est elle qui crée son coffre et choisit le mot de passe, sans vous.
  Lui faire noter ce mot de passe sur papier : s'il est perdu, personne ne peut l'ouvrir.
- **Revenir en arrière** : au démarrage, le menu s'affiche quelques secondes ;
  avec les flèches, choisir une version plus ancienne. À lui montrer une fois.
- **Dépannage à distance** : elle ouvre RustDesk, vous donne l'identifiant et le
  code à usage unique, puis accepte la fenêtre de partage d'écran. Ne jamais
  activer d'accès « sans surveillance » ni de mot de passe permanent dans RustDesk.

## À tester avant de lui rendre l'ordinateur

- [ ] Wi-Fi, y compris sous forte charge (gros téléchargement)
- [ ] Mise en veille et réveil en fermant / rouvrant l'écran
- [ ] Déverrouillage du disque au démarrage (clavier bien en AZERTY Mac)
- [ ] Dock visible, boutons de fenêtre à gauche, installation d'une appli dans « Logiciels »
- [ ] Une session RustDesk depuis chez vous
- [ ] Un cycle complet : modifier `personal.nix`, pousser, vérifier que le MacBook l'applique
      (en `depannage` : `sudo systemctl start nixos-upgrade`, puis `journalctl -u nixos-upgrade`)
- [ ] Le retour à une version précédente depuis le menu de démarrage
- [ ] La webcam, si `webcam = true`
- [ ] Une restauration depuis la sauvegarde, si elle est activée

## Au quotidien

- Ajouter une appli pour elle : l'ajouter dans `personal.nix`, pousser.
- Changer de version de NixOS : se fait dans le socle, pas ici.
- Ne jamais modifier `system.stateVersion` ni `home.stateVersion`.
