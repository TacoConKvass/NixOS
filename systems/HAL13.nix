{ stable, unstable, wsl, system, self, ... }: stable.lib.nixosSystem {
  pkgs = import stable { inherit system; };
  specialArgs.unstable = import unstable { inherit system; };
  specialArgs.self = self;

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
