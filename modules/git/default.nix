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
    };

    config = lib.mkIf cfg.enable {
        environment.${pkgsAttr} = [ pkgs.${gcm} ];

        programs.git = lib.mkIf cfg.enable {
            enable = true;
            config = {
                credential.helper = "${pkgs.${gcm}}/bin/${gcm}";
                # Unsafe, but should work everywhere.
                # TODO: Change as soon as possible
                credential.credentialStore = "plaintext"; 
                user.name = cfg.username;
                user.email = cfg.email;
            };
        };
    };
}
