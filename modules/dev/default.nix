{ config, pkgs, lib, ... } : let 
    cfg = config.modules.dev;
    pkgsAttr = if (builtins.hasAttr "packages" config.environment) then "packages" else "systemPackages";
in {
    options.modules.dev = {
        zig = lib.mkEnableOption "Ensure the Zig compiler is installed";
        rust = lib.mkEnableOption "Ensure tools for Rust development are installed";
        cSharp = lib.mkEnableOption "Ensure tools for C# development are installed";
    };

    config = {
        environment.${pkgsAttr} = ([]
            ++ (lib.optionals cfg.zig [ pkgs.zig ])
            ++ (lib.optionals cfg.rust [ pkgs.cargo pkgs.rustc pkgs.gcc ])
            ++ (lib.optionals cfg.cSharp [ pkgs.dotnetCorePackages.dotnet_8.sdk ])
        );

        modules.neovim.additionalPackages = []
            ++ (lib.optionals cfg.zig [ pkgs.zls ])
            ++ (lib.optionals cfg.rust [ pkgs.rust-analyzer ])
            ++ (lib.optionals cfg.cSharp [ pkgs.roslyn-ls ]);
    };
}
