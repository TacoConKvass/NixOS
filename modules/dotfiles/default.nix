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
                    additionalLines = lib.mkOption {
                        type = types.str;
                        default = "";
                        description = "Additional lines to be added to the config";
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
                };
            });
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
        in {
            name = "setup${dotfile.name}";
            value = ''
                # ${dotfile.value.source}
                ${dotfile.value.preSetup}
                if [ -f ${filePath} ]; then
                echo ${dotfile.name} config found...
                else
                mkdir -p ${filePath}
                rm -rf ${filePath}
                cat ${sourceFile} > ${filePath}
                cat >> ${filePath} << 'EOF'
                ${dotfile.value.additionalLines}
                EOF
                fi
                ${dotfile.value.postSetup}
            '';
        }) dotfiles); 
        
    };
}
