{
  description = "NixOS de Alice (MacBook Air 13 pouces, 2017)";

  # Le socle fixe nixpkgs, Home Manager, etc. : pas d'autre entrée ici.
  inputs.base.url = "github:Nixos-config-friends/nixos-base";

  outputs =
    { base, ... }:
    {
      nixosConfigurations.macbook-alice = base.lib.mkHost {
        hostname = "macbook-alice";
        modules = [
          ./hardware-configuration.nix
          ./personal.nix
        ];
      };
    };
}
