{ pkgs, self, ... } : self.lib.mkUser "taco" {
  description = "TacoConKvass";
  isNormalUser = true;

  home = "/home/taco";
  createHome = true;

  group = "users";
  extraGroups = [ "wheel" ];

  dev.dotnet.enable = true;
  dev.zig.enable = true;

  git.enable = true;
  git = {
    username = "TacoConKvass";
    email = "e_frun@o2.pl";

    additional = {
      core = {
        filemode = false;
        autocrlf = true;
        eol = "crlf";
      };
    };
  };

  desktop.enable = true;
  desktop = {
    environment = pkgs.niri;
    programs = [
      # Core
      pkgs.fuzzel pkgs.swaybg pkgs.waybar 
      # User programs
      pkgs.foot
    ];
    fonts = [ pkgs.nerd-fonts.sauce-code-pro ];
    startupCommand = "niri --session;";
  };

  files.home = {
    ".config/foot/foot.ini".source = ./dotfiles/taco/foot.ini;
    ".config/foot/foot.ini".copy = true;
    ".config/fuzzel/fuzzel.ini".source = ./dotfiles/taco/fuzzel.ini;
    ".config/helix/config.toml".source = ./dotfiles/taco/helix-config.toml;
    ".config/helix/languages.toml".source = ./dotfiles/taco/helix-languages.toml;
    ".config/niri/config.kdl".source = ./dotfiles/taco/niri.kdl;
    ".config/waybar/style.css".source = ./dotfiles/taco/waybar-style.css;
    ".config/waybar/config.jsonc".source = ./dotfiles/taco/waybar-layout.jsonc;
    ".confg/wallpaper.png".source = ./dotfiles/taco/wallpaper.png;
    ".bashrc".source = ./dotfiles/taco/bashrc.sh;
  };
}
