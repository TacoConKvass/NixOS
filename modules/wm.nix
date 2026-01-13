{ config, lib, pkgs, ... } : let
    types = lib.types;
    cfg = config.features.wm;
    mkPkgOption = description: default: lib.mkOption { type = types.package; inherit description; inherit default; };
in {
    options.features.wm = {
        enable = lib.mkEnableOption "Enable WM";
        apps = lib.mkOption {
            type = types.listOf types.package;
            description = "Apps to make available";
            default = [];
        };
        packages = {
            main = mkPkgOption "Main window manager package" pkgs.niri;
            bar = mkPkgOption "Bar package" pkgs.waybar;
            launcher = mkPkgOption "App launcher" pkgs.fuzzel;
            background = mkPkgOption "Background utility" pkgs.swaybg;
            explorer = lib.mkOption {
                type = types.listOf types.package;
                description = "File explorer packages";
                default = [];
            };
        };
        fonts = lib.mkOption {
            type = types.listOf types.package;
            description = "Fonts to install";
            default = [];
        };
    };

    config = lib.mkIf (cfg.enable) {
        environment.systemPackages = with cfg.packages; [ 
            main bar launcher background
        ] ++ cfg.packages.explorer ++ cfg.apps;

        fonts.packages = cfg.fonts;
    };
}
