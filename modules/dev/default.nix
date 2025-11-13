{ config, pkgs, lib, ... } : let 
    cfg = config.modules.dev;
    dotnetPkgs = pkgs.dotnetCorePackages;
in {
    options.modules.dev = {
        zig =  {
            enable = lib.mkEnableOption "Ensure the Zig compiler is installed";
            package = lib.mkOption {
                type = lib.types.package;
                default = pkgs.zig;
                description = "Package to pull as the Zig compiler";
            };
            lsp = lib.mkOption {
                type = lib.types.package;
                default = pkgs.zls;
                description = "Package to pull as the Zig language server";
            };
        };
        rust = lib.mkEnableOption "Ensure tools for Rust development are installed";
        cSharp = lib.mkEnableOption "Ensure tools for C# development are installed";
    };

    config = {
        environment.systemPackages = ([]
            ++ (lib.optionals cfg.zig.enable [ cfg.zig.package ])
            ++ (lib.optionals cfg.rust [ pkgs.cargo pkgs.rustc pkgs.gcc ])
            ++ (lib.optionals cfg.cSharp [(
                dotnetPkgs.combinePackages [
                    dotnetPkgs.dotnet_8.sdk
                    dotnetPkgs.dotnet_9.sdk
                    dotnetPkgs.sdk_10_0-bin
                    pkgs.dotnetPackages.Nuget
                ]
            )])
        );

        modules.neovim.additionalPackages = []
            ++ (lib.optionals cfg.zig.enable [ cfg.zig.lsp ])
            ++ (lib.optionals cfg.rust [ pkgs.rust-analyzer ])
            ++ (lib.optionals cfg.cSharp [ pkgs.roslyn-ls ]);
    };
}
