lib: let
  inherit (lib) types;
  funcModule = func: types.attrsOf (types.submodule func);
  namedModule = name: attrs: types.attrsOf (types.submodule { options.${name} = attrs; });
  namedSubmodules = options: types.attrsOf (types.submodule { inherit options; });
in {
  types = { inherit namedModule namedSubmodules funcModule; };

  mkNamedSubmodules = description: options: lib.mkOption {
    type = namedSubmodules options;
    inherit description;
    default = {};
  };

  mkNamedModule = name: description: attrs: lib.mkOption {
    type = namedModule name attrs;
    inherit description;
    default = {};
  };

  mkUsersModule = name: attrs: lib.mkOption {
    type = namedModule name attrs;
  };

  mkUsersFuncModule = func: lib.mkOption {
    type = funcModule func;
  };

  mkPackageOption = description: default: lib.mkOption {
    type = types.package;
    inherit description default;
  };

  mkPackageListOption = description: default: lib.mkOption {
    type = types.listOf types.package;
    inherit description default;
  };

  mkUser = name: attrs: { users.users.${name} = attrs; };
}
