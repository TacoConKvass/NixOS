{ stable, unstable, wsl, system, ... }: stable.lib.nixosSystem {
  pkgs = import stable { inherit system; };
  specialArgs.unstable = import unstable { inherit system; };

  modules = [
    ./../modules
    ./../users/taco.nix
    ./../hosts/HAL13.nix
    wsl.nixosModules.default {
      wsl.enable = true;
      wsl.useWindowsDriver = true;
      wsl.defaultUser = "taco";
    }
  ];
}
