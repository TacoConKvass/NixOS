{
    description = "Nix(OS) config";

    inputs = {
        nixdroid-pkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
        nixdroid = {
            url = "github:nix-community/nix-on-droid/release-24.05";
            inputs.nixpkgs.follows = "nixdroid-pkgs";
        };

        stable.url = "github:NixOS/nixpkgs/nixos-26.05";
        unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

        wsl.url = "github:nix-community/NixOS-WSL/2411.6.0";
    };

    outputs = { stable, unstable, self, ... } @ inputs : let
        arm = "aarch64-linux";
        x86 = "x86_64-linux";
        i686 = "i686-linux";
    in {
        devShell.${x86} = let pkgs = import inputs.stable { system = x86; }; in pkgs.mkShell {
            buildInputs = [ pkgs.nil ];
        };
    };
}
