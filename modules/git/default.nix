{ config, lib, pkgs, ... } : let
    cfg = config.modules.git;
    gcm = "git-credential-manager";
in {
    options.modules.git = {
        enable = lib.mkEnableOption "Enable Git";
        config = {
            enable = lib.mkEnableOption "Setup .gitconfig";
            username = lib.mkOption {
                type = lib.types.str;
                description = "Username used for Git";
            };
            email = lib.mkOption {
                type = lib.types.str;
                description = "Email used for Git";
            };
            gcm = {
                enable = lib.mkEnableOption "Enable Git Credential Manager";
                storeType = lib.mkOption {
                    type = lib.types.enum ["cache" "plaintext" "gpg"];
                    description = ''What storing mechanism to use
                        "cache" - timed cache, keeps credentials for 15 minutes
                        "plaintext" - keeps credentials in plaintext - DO NOT USE UNLESS NO OTHER OPTION IS AVAILABLE
                        "gpg" - GPG/pass compatible files

                        Information taken from: https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/credstores.md
                    '';
                };
                cacheOptions = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                    description = ''Credentials cache options. Only take effect if gcm.storeType is set to "cache"'';
                };
            };
            user = lib.mkOption {
                type = lib.types.attrs;
                description = "User to whom the generated .gitconfig will belong";
            };
        };
        package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.git;
            description = "Git package";
        };
    };

    config = lib.mkIf (cfg.enable) {
        environment.systemPackages = ([ cfg.package ]
            ++ (lib.optionals cfg.config.gcm.enable ([ pkgs.${gcm} ]
                ++ lib.optionals (cfg.config.gcm.storeType == "gpg") [ pkgs.pass ]
            ))
        );

        system.activationScripts.setupGit = (if (!cfg.config.enable) then "" else
            let
                gitconfig = "${cfg.config.user.home}/.gitconfig";
            in ''
            echo "setting up ${gitconfig}..."
            if [ ! -f ${gitconfig} ]; then
                echo '[core]
                filemode = false
                core.eol = crlf
            [user]
                name = "${cfg.config.username}"
                email = "${cfg.config.email}"
            '' +
            (if (!cfg.config.gcm.enable) then "" else ''
            [credential]
                helper = ${"${pkgs.${gcm}}/bin/${gcm}"}
                credentialStore = "${cfg.config.gcm.storeType}"
                cacheOptions = "${cfg.config.gcm.cacheOptions}"
            '') + ''
            ' > ${gitconfig}
                chown ${cfg.config.user.name}:${cfg.config.user.group} ${gitconfig}
            fi
        '');
    };
}
