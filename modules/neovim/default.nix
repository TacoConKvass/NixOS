{ config, pkgs, lib, ... }: let
    cfg = config.modules.neovim;
    repo = cfg.config.repository;
    pkgsAttr = if (builtins.hasAttr "packages" config.environment) then "packages" else "systemPackages";
in {
    options.modules.neovim = {
        enable = lib.mkEnableOption "Ensures Neovim is installed";
        config = {
            pull = lib.mkEnableOption "Auto pulls config from a git repository into ~/config/nvim";
            repository = {
                url = lib.mkOption {
                    type = lib.types.str;
                    description = "The git repository to pull the configuration from";
                };
                branch = lib.mkOption {
                    type = lib.types.str;
                    description = "Branch to pull";
                };
            };
            home = lib.mkOption {
                type = lib.types.path;
                description = "Home path";
            };
        };
        additionalPackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [];
            description = "Pacakges to install alongside Neovim";
        };
    };

    config = {
        environment.${pkgsAttr} = lib.mkIf cfg.enable ([ pkgs.neovim ]
            ++ lib.optionals cfg.config.pull [ pkgs.git ]
            ++ cfg.additionalPackages
        );

        system.activationScripts = {
            neovimSetup.text = if (cfg.config.pull) then ''
                if [ ! -d ${cfg.config.home}/.config/nvim ]; then
                    echo "Pulling Neovim config..." 
                    ${pkgs.git}/bin/git clone -b ${repo.branch} ${repo.url} ${cfg.config.home}/.config/nvim
                fi
            '' else "";
        };
    };
}
