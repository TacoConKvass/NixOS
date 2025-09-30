{ config, pkgs, lib, ... }: let
    cfg = config.modules.neovim;
    repo = cfg.config.repository;
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
            user = lib.mkOption {
                type = lib.types.attrs;
                description = "User to whom the generated config will belong";
            };
            gitPackage = lib.mkOption {
                type = lib.types.package;
                default = pkgs.git;
                description = "Neovim package";
            };
        };
        package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.neovim;
            description = "Neovim package";
        };
        additionalPackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [];
            description = "Pacakges to install alongside Neovim";
        };
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = ([ cfg.package pkgs.lua-language-server pkgs.nil pkgs.ripgrep ]
            ++ lib.optionals cfg.config.pull [ cfg.config.gitPackage ]
            ++ cfg.additionalPackages
        );

        system.activationScripts.setupNeovim = (if (!cfg.config.pull) then "" else
        let
            configDir = "${cfg.config.user.home}/.config/nvim";
        in ''
            if [ ! -d ${configDir} ]; then
               echo "Pulling Neovim config..."
               ${pkgs.git}/bin/git clone -b ${repo.branch} ${repo.url} ${configDir}
               chown --recursive ${cfg.config.user.name}:${cfg.config.user.group} ${configDir}
            else
                echo "Neovim config found..."
            fi
        '');
    };
}
