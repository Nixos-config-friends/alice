{
  description = "NixOS de Marie (MacBook Air 13 pouces, 2017)";

  # Le socle fixe nixpkgs, Home Manager, etc. : pas d'autre entrée ici.
  inputs.base.url = "github:VOTRE-COMPTE/nixos-proches";

  outputs =
    { base, ... }:
    {
      nixosConfigurations.macbook-marie = base.lib.mkHost {
        hostname = "macbook-marie";
        modules = [
          ./hardware-configuration.nix
          ./personal.nix
        ];
      };
    };
}
