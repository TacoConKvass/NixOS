{ lib, self, pkgs, ... } : let
  lib' = lib.recursiveUpdate lib self.lib;
in {
  options.users.users = lib'.mkUsersFuncModule ({ config, ... } : {
    options.dev = {
      zig = {
        enable = lib'.mkEnableOption "Enable Zig development";
        compiler = lib'.mkPackageOption "Zig compiler" pkgs.zig;
        languageServer = lib'.mkPackageOption "ZLS package" pkgs.zls;
      };

      dotnet = {
        enable = lib'.mkEnableOption "Enable .NET development";
        sdks = lib'.mkPackageOption ".NET SDKs" (pkgs.dotnetCorePackages.combinePackages [
            pkgs.dotnet-sdk
            pkgs.dotnet-sdk_11
            pkgs.nuget
          ]);
        languageServer = lib'.mkPackageOption "Main .NET LSP package" pkgs.omnisharp-roslyn;
        additional = lib'.mkPackageListOption "Additional packages" [];
      };

      rust = {
        enable = lib'.mkEnableOption "Enable Rust development";
        toolchain = lib'.mkPackageOption "Rust toolchain packages" [ pkgs.rustc pkgs.cargo pkgs.gcc ];
        languageServer = lib'.mkPackageOption "Main Rust LSP package" pkgs.rust-analyzer;
        additional = lib'.mkPackageListOption "Additional packages" [];
      };
    };

    config = {
      packages = lib'.concatLists [
          (with config.dev.zig;    (lib'.optionals enable ([ languageServer compiler ])))
          (with config.dev.rust;   (lib'.optionals enable ([ languageServer ] ++ toolchain ++ additional)))
          (with config.dev.dotnet; (lib'.optionals enable ([ languageServer sdks ] ++ additional)))
        ];

      variables = lib.mkIf config.dev.dotnet.enable {
        DOTNET_ROOT = "${config.dev.dotnet.sdks}/share/dotnet";
      };
    };
  });
}
