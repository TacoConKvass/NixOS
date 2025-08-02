{ config, pkgs, lib, ... } : let 
    cfg = config.modules.dev;
    pkgsAttr = if (builtins.hasAttr "packages" config.environment) then "packages" else "systemPackages";
in {
    options.modules.dev = {
        zig = lib.mkEnableOption "Ensure the Zig compiler is installed";
        rust = lib.mkEnableOption "Ensure tools for Rust development are installed";
    };

    config = {
        environment.${pkgsAttr} = ([]
            ++ (lib.optionals cfg.zig [ pkgs.zig ])
            ++ (lib.optionals cfg.rust [ pkgs.cargo pkgs.rustc pkgs.gcc ])
        );
    };
}
