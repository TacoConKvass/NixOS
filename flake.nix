{
    description = "Nix(OS) config";

    inputs = {
        nixdroid-pkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
        nixdroid = {
            url = "github:nix-community/nix-on-droid/release-24.05";
            inputs.nixpkgs.follows = "nixdroid-pkgs";
        };

        pkgs-25-05.url = "github:NixOS/nixpkgs/nixos-25.05";
        pkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

        wsl.url = "github:nix-community/NixOS-WSL/2411.6.0";

        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "pkgs-unstable";
        };
    };

    outputs = { ... } @ inputs : let
        arm = "aarch64-linux";
        x86 = "x86_64-linux";
    in {
        nixOnDroidConfigurations.default = inputs.nixdroid.lib.nixOnDroidConfiguration {
            pkgs = import inputs.pkgs-25-05 { system = arm; };
            modules = [
                ./hosts/nixdroid.nix
            ];
            extraSpecialArgs = {
                unstable = inputs.pkgs-unstable.legacyPackages.${arm};
            };
        };

        nixosConfigurations.HAL11 = inputs.pkgs-25-05.lib.nixosSystem {
            system = x86;
            modules = [
                ./hosts/HAL11.nix
                inputs.wsl.nixosModules.default {
                    system.stateVersion = "24.11";
                    wsl.enable = true;
                    wsl.useWindowsDriver = true;
                }
            ];
            specialArgs = {
                unstable = inputs.pkgs-unstable.legacyPackages.${x86};
                zen-browser = inputs.zen-browser.packages.${x86};
            };
        };
    };
}
