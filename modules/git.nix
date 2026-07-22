{ lib, self, pkgs, ... } : let
  lib' = lib.recursiveUpdate lib self.lib;
  inherit (lib') types;
in {
  options.users.users = lib'.mkUsersFuncModule ({ config, ... } : {
    options.git = {
      enable = lib'.mkEnableOption "Enable Git config generation";
      package = lib'.mkOption {
        type = types.package;
        description = "Git package to expose to the user";
        default = pkgs.git;
      };
      username = lib'.mkOption {
        type = types.str;
        description = "Username to use in Git";
      };
      email = lib'.mkOption {
        type = types.str;
        description = "Email address to use in Git";
      };
      additional = lib'.mkOption {
        type = types.attrsOf types.anything;
        description = "Additional Git config not covered by previous options";
        default = {};
      };
    };

    config = let
      cfg = config.git;
    in lib'.mkIf cfg.enable {
      packages = [ cfg.package ];
      files.home.".config/git/config".text = lib'.generators.toGitINI ({
          user.name = cfg.username;
          user.email = cfg.email;
        } // cfg.additional);
    };
  });
}
