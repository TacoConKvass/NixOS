{ config, lib, pkgs, unstable, ... } : let
    types = lib.types;
    cfg = config.features.niri;
    mkPkgOption = description: default: lib.mkOption { type = types.package; inherit description; inherit default; };
in {
    options.features.niri = {
        enable = lib.mkEnableOption "Enable Niri WM";
        apps = lib.mkOption {
            type = types.listOf types.package;
            description = "Apps to make available";
            default = [];
        };
        packages = {
            main = mkPkgOption "Main Niri package" unstable.niri;
            bar = mkPkgOption "Bar package" pkgs.waybar;
            launcher = mkPkgOption "App launcher" pkgs.fuzzel;
            background = mkPkgOption "Background utility package" pkgs.swaybg;
        };
    };

    config = lib.mkIf (cfg.enable) {
        environment.systemPackages = with cfg.packages; [ 
            main bar launcher background
        ] ++ cfg.apps;
    };
}
