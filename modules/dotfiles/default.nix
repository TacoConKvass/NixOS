{ config, lib, ... } : let
  cfg = config.modules.dotfiles;
  dotfiles = lib.attrsToList cfg.definitions;
  types = lib.types;
in {
    options.modules.dotfiles = {
        definitions = lib.mkOption {
            type = types.attrsOf (types.submodule {
                options = {
                    path = lib.mkOption {
                        type = types.str;
                        description = "The dotfile's target path relative to $HOME";
                    };
                    source = lib.mkOption {
                        type = types.path;
                        description = "Path to the source file";
                    };
                    preSetup = lib.mkOption {
                        type = types.str;
                        default = "";
                        description = "Bash script to execute before this dotfile is set up";
                    };
                    postSetup = lib.mkOption {
                        type = types.str;
                        default = "";
                        description = "Bash script to execute after this dotfile is set up";
                    };
                    overwrite = lib.mkOption {
                        type = types.bool;
                        default = false;
                        description = "Always overwrite the dotfile";
                    };
                };
            });
            default = {};
            description = "Dotfile definitions";
        };
        user = lib.mkOption {
            type = types.attrs;
            description = "User to whom the dotfiles belong";
        };
    };

    config = {
        system.activationScripts = lib.listToAttrs (builtins.map (entry: let
            dotfile = {
                name = entry.name;
                value = entry.value;
            };
            filePath = "${cfg.user.home}/${dotfile.value.path}";
            sourceFile = "${dotfile.value.source}";
            shortcircut = if dotfile.value.overwrite then "&& false" else "";
        in {
            name = "setup${dotfile.name}";
            value = ''
                # ${dotfile.value.source}
                ${dotfile.value.preSetup}
                if [ -f ${filePath} ] ${shortcircut}; then
                echo ${dotfile.name} config found...
                else
                echo "setting up ${dotfile.name}..."
                mkdir -p ${filePath}
                rm -rf ${filePath}
                cp -rf ${sourceFile} ${filePath}
                chown -R ${cfg.user.name} ${filePath}
                fi
                ${dotfile.value.postSetup}
            '';
        }) dotfiles); 
        
    };
}
