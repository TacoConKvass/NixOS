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
        dotnet = lib.mkEnableOption "Ensure tools for .NET development are installed";
    };

    config = {
        environment.systemPackages = ([]
            ++ (lib.optionals cfg.zig.enable [ cfg.zig.package ])
            ++ (lib.optionals cfg.rust [ pkgs.cargo pkgs.rustc pkgs.gcc ])
        );

        modules.neovim.additionalPackages = []
            ++ (lib.optionals cfg.zig.enable [ cfg.zig.lsp ])
            ++ (lib.optionals cfg.rust [ pkgs.rust-analyzer ])
            ++ (lib.optionals cfg.dotnet [ pkgs.roslyn-ls ]);
    } // (lib.mkIf cfg.dotnet
        (let
            dotnet_pkg = dotnetPkgs.combinePackages [
                dotnetPkgs.dotnet_8.sdk
                dotnetPkgs.sdk_10_0-bin
                pkgs.dotnetPackages.Nuget
            ];
        in {
            environment.systemPackages = [ dotnet_pkg ];

            environment.sessionVariables = {
                DOTNET_ROOT = "${dotnet_pkg}/share/dotnet";
            };
        })
    );
}
