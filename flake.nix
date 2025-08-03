{
    description = "Nix(OS) config";

    inputs = {
        nixdroid-pkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
        nixdroid = {
            url = "github:nix-community/nix-on-droid/release-24.05";
            inputs.nixpkgs.follows = "nixdroid-pkgs";
        };
        
        pkgs-25-05.url = "github:NixOS/nixpkgs/nixos-25.05";
    
        wsl.url = "github:nix-community/NixOS-WSL/2411.6.0";
    };

    outputs = { ... } @ inputs : 
        let
            arm = "aarch64-linux";
            x86 = "x86_64-linux";
        in
    {
        nixOnDroidConfigurations.default = inputs.nixdroid.lib.nixOnDroidConfiguration {
            pkgs = import inputs.pkgs-25-05 { system = arm; };
            modules = [
                ./hosts/nixdroid
                inputs.pkgs-25-05.nixos.modules
            ];
        };

        nixosConfigurations.wsl = inputs.pkgs-25-05.lib.nixosSystem {
            system = x86;
            modules = [
                ./hosts/wsl
                inputs.wsl.nixosModules.default {
                    system.stateVersion = "24.11";
                    wsl.enable = true;
                }
            ];
        };
    };
}
