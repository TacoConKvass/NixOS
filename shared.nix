{ config, pkgs, ... } : let
    pkgsAttr = if (builtins.hasAttr "packages" config.environment) then "packages" else "systemPackages";
in {
    environment.${pkgsAttr} = with pkgs; [
        coreutils
        git
        vim
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];
}
