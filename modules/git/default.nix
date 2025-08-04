{ config, lib, pkgs, ... } : let
    cfg = config.modules.git;
    gcm = "git-credential-manager";
    isAndroid = builtins.pathExists /storage/emulated;
    at = index: list: builtins.elemAt list index;
    pkgsAttr = if (isAndroid) then "packages" else "systemPackages";
    scriptAttr = lib.splitString "." (if (isAndroid) then "build.activationAfter" else "system.activationScripts");
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
            home = lib.mkOption {
                type = lib.types.path;
                description = "Home path to put .gitconfig into";
            };
        };
        package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.git;
            description = "Git package";
        };
    };

    config = lib.mkIf (cfg.enable) {
        environment.${pkgsAttr} = ([ cfg.package ]
            ++ (lib.optionals cfg.config.gcm.enable ([ pkgs.${gcm} ]
                ++ lib.optionals (cfg.config.gcm.storeType == "gpg") [ pkgs.pass ]
            ))
        );

        ${at 0 scriptAttr}.${at 1 scriptAttr}.setupGit = ((lib.mkIf cfg.config.enable) ''
            if [ ! -d ${cfg.config.home}/.gitconfig ]; then
                echo "Creating Git config in ${cfg.config.home}..."
                echo '
            [user]
                name = "${cfg.config.username}"
                email = "${cfg.config.email}"
            [credential]
                helper = ${"${pkgs.${gcm}}/bin/${gcm}"}
                credentialStore = "${cfg.config.gcm.storeType}"
                cacheOptions = "${cfg.config.gcm.cacheOptions}"
            ' > ${cfg.config.home}/.gitconfig
            else
                echo "Git config found..."
            fi
        '');
    };
}
