{ config, lib, ... } : let
    types = lib.types;
    files = lib.attrsToList config.files;
in {
    options.files = lib.mkOption {
        type = types.attrsOf (types.submodule {
            options = {
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
        description = "File definitions";
    };

    config = {
        system.activationScripts = lib.listToAttrs (builtins.map (entry: let
            path = entry.name;
            opts = entry.value;
            overwrite = if (opts.overwrite) then "true" else "false";
        in {
            name = "setup ${path}";
            value = ''
                ${opts.preSetup}
                echo "setting up ${path}..."
                if [[ ! -f ${path} ]] || ${overwrite}; then
                    if [[ ! -f ${path} ]]; then
                        mkdir -p ${path}
                    fi
                    rm -rf ${path}
                    echo "    - copying from the nix-store..."
                    cp -rf ${opts.source} ${path}
                    chown :users ${path}
                    chmod g+w ${path}
                fi
                ${opts.postSetup}
            '';
        }) files);
    };
} 
