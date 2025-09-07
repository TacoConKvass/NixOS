{ config, lib, ... } : let
    bash = config.modules.bash;
in {
    options.modules.bash = {
        enable = lib.mkEnableOption "Enable auto .bashrc generation";
        additionalConfig = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Config added to the end of .bashrc";
        };
        user = lib.mkOption {
            type = lib.types.attrs;
            description = "The user to apply the config to";
        };
        preSetup = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Bash script executed before the setupBash script";
        };
        postSetup = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Bash script executed after the setupBash script";
        };
    };

    config = lib.mkIf bash.enable {
        system.activationScripts.setupBash = let
            file = "${bash.user.home}/.bashrc";
        in ''
            ${bash.preSetup}
            if [ -f ${file} ]; then
                echo ".bashrc found..."
            else
                echo "Generating ${file}..."
                echo "PS1=\"\n⎧ taco ❱ \[\$(tput setaf 104)\]\w \[\$(tput sgr0)\]\n⎩ $ \"
            function lastcommand {
                history | tail -1 | cut -c 8-
            }

            function deleteprompt {
                n=\''${PS1@P}
                n=\''${n//[^$'\n']}
                n=\''${#n}
                tput cuu \$((n + 1))
                tput ed
            }

            PS0='\[\$(deleteprompt)\]\$ \$(lastcommand)\n\[\''${PS1:0:\$((EXPS0=1,0))}\]'
            PROMPT_COMMAND='[ \"\$EXPS0\" = 0 ] && deleteprompt && echo -e \"\$\" || EXPS0=0'

            alias ls=\"ls --color=auto\"
            ${bash.additionalConfig}" > ${file}
            fi
            ${bash.postSetup}
        '';
    };
}
