{ lib, self, config, ... } : let
  lib' = lib.recursiveUpdate lib self.lib;
  inherit (lib') types;  
in {
  options = let
    mkFilesOption = description: lib'.mkNamedSubmodules description {
        source = lib'.mkOption {
          type = types.nullOr (types.either types.str types.path);
          description = "Path to the source file";
        };
        text = lib'.mkOption {
          type = types.nullOr types.str;
          description = "Contents of the file";
        };
        copy = lib'.mkEnableOption "Copy instead of linking";
      };
  in {
    files = mkFilesOption "User file generation";

    users.users = lib'.mkUsersModule "files" {
      home = mkFilesOption "Files relative to the users `home`";
      root = mkFilesOption "Files with an absolute path from the `/` directory";
    };
  };

  config = let
    userFiles = lib'.concatLists (lib'.map ({ home, files, ... }:
        (lib'.mapAttrsToList (name: value: {
            name = "/${name}";
            inherit value;
          }) files.root
        ) ++
        (lib'.mapAttrsToList (name: value: {
            name = "${home}/${name}";
            inherit value;
          }) files.home
        )
      ) (lib'.attrValues config.users.users));
    
    fileList = (lib'.attrsToList config.files) ++ userFiles; # [ { name , { source, text } }, ... ]
    splitPath = path: lib'.splitStringBy (_: now: now == "/") false path;
    mkStoreName = path: lib'.concatStringsSep "-" (splitPath path); # /home/user/name => -home-user-name

    mkFile = path: value:  lib'.warnIf (value.source != null && value.text != null)
      "Both `source` and `text` are set for ${path}, `source` takes precedence"
      (if (value.source != null) then value.source else lib'.toFile (mkStoreName path) value.text);    
    mkListEntry = { name, value }: { path = name; storeFile = mkFile name value; inherit (value) copy; };
    skipLast = list: lib'.sublist 0 ((lib'.length list) - 1) list;

    getDirectory = path: let
        pathList = splitPath path;
      in lib'.concatStringsSep "/" (skipLast pathList);
    files = lib'.map (mkListEntry) fileList;
    mkCommand = entry: ''
      mkdir -p ${getDirectory entry.path}
      ${if entry.copy then "cp -f" else "ln -s -f"} ${entry.storeFile} ${entry.path}
      '';
  in {
    system.activationScripts.setupUserFiles = ''
        echo "Setting up user files"
        ${lib'.concatStringsSep "" (lib'.map (mkCommand) files)}
      '';
  };
}
