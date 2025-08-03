{ config, lib, pkgs, ... } : let
    cfg = config.modules.git;
    pkgsAttr = if (builtins.hasAttr "packages" config.environment) then "packages" else "systemPackages";
    gcm = "git-credential-manager";
in {
    options.modules.git = {
        enable = lib.mkEnableOption "Enable Git";
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
            store = lib.mkOption {
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
                description = ''Credentials cache options. Only take effect if gcm.store is set to "cache"'';
            };
        };
    };

    config = lib.mkIf cfg.enable {
        environment.${pkgsAttr} = lib.mkIf cfg.gcm.enable ([ pkgs.${gcm} ]
            ++ lib.optionals (cfg.gcm.store == "gpg") [ pkgs.pass ]
        );

        programs.git = lib.mkIf cfg.enable {
            enable = true;
            config = {
                credential = lib.mkIf cfg.gcm.enable {
                    helper = "${pkgs.${gcm}}/bin/${gcm}";
                    credentialStore = cfg.gcm.store;
                    cacheOptions = lib.mkIf (cfg.gcm.store == "cache") (cfg.gcm.cacheOptions);
                };
                user.name = cfg.username;
                user.email = cfg.email;
            };
        };
    };
}
