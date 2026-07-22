{ lib, self, config, pkgs, ... } : let
  lib' = lib.recursiveUpdate lib self.lib;
  inherit (lib') types;
in {
  options.users.users = lib'.mkUsersFuncModule ({ config, ... }: let cfg = config.desktop; in {
    options.desktop = {
      enable = lib'.mkEnableOption "Enable the desktop environment";

      environment = lib'.mkOption {
        type = types.package;
        description = "The user's DE/WM";
      };
      programs = lib'.mkPackageListOption "Programs to install when the desktop environment is enabled" [];
      fonts = lib'.mkPackageListOption "Fonts to install into the system" [];
      startupCommand = lib'.mkOption {
        type = types.nullOr types.str;
        description = "Custom startup command for the desktop environment. `exec name` by default";
        default = null;
      };
    };

    config = lib.mkIf cfg.enable {
      packages = [ cfg.environment ] ++ cfg.programs;
      extraGroups = [ "seat" ];
    };
  });

  config = let
    configs = lib'.filterAttrs (_: user: user.desktop.enable) config.users.users;
  in {
    services.displayManager.lemurs = lib'.mkIf (!(config ? wsl) || !config.wsl.enable) {
      enable = true;
      settings = {
        username_field.remember = false;
      };
    };

    systemd.packages = (lib'.concatLists (
        lib'.map (user: [ user.desktop.environment ]) (lib'.attrValues configs)
      ));

    fonts.packages = (lib'.concatLists (
        lib'.map (user: user.desktop.fonts) (lib'.attrValues configs)
      ));

    environment.etc."lemurs/wayland/auto".source = pkgs.writeShellScript "lemurs-auto-select" "
        ${
          lib'.concatStringsSep "\n" (lib.map (user: ''
              if [ $USER == ${user.name} ]; then
                ${if user.desktop.startupCommand == null then "exec ${lib'.getExe user.desktop.environment}" else user.desktop.startupCommand}
                exit;
              fi
            '') (lib'.attrValues configs))
        }
      ";
  };
}
