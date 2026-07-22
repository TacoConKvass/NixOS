{ lib, self, config, ... } : let
  lib' = lib.recursiveUpdate lib self.lib;
  inherit (lib') types;
in {
  options.users.users = lib'.mkUsersModule "variables" (lib'.mkOption {
    type = types.attrsOf types.str;
    description = "Environment variables to be set for this user";
    default = {};
  });

  config.environment.extraInit = lib'.concatStringsSep "\n" (lib'.map (
      { name, variables, ... } : let
        exportVar = n: v: "export ${n}=\"${v}\"";
      in 
        ''
          if [ $USER == ${name} ]; then
            ${lib.concatStringsSep "\n" (lib.mapAttrsToList (exportVar) variables)}
          fi;
        ''
    ) (lib'.attrValues (lib'.filterAttrs (_: u: u.variables != {}) config.users.users)));
}
