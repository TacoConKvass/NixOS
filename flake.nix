{
    description = "Nix(OS) config";

    inputs = {
        # Main flake inputs
        stable.url = "github:NixOS/nixpkgs/nixos-26.05";
        unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

        # Auxillary inputs for specific machines
        wsl.url = "github:nix-community/NixOS-WSL/2411.6.0";
        wsl.inputs.nixpkgs.follows = "stable";

        # nixdroid.url = "github:nix-community/nix-on-droid/release-24.05";
    };

    outputs = { stable, ... }@inputs : let
        arm = "aarch64-linux";
        x86_64 = "x86_64-linux";
        i686 = "i686-linux";

        makeSystem = name: system: import ./systems/${name}.nix (inputs // { inherit system; });
    in {
        nixosConfigurations.HAL13         = makeSystem "HAL13" x86_64;
        nixosConfigurations.NCC-686       = makeSystem "NCC-686" i686;
        nixOnDroidConfigurations.nixdroid = makeSystem "nixdroid" arm;
        
        devShell.${x86_64} = let
            pkgs = import stable { system = x86_64; };
        in pkgs.mkShell {
            buildInputs = [ pkgs.nil ];
        };
    };
}
