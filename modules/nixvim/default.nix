{ ... }:
{

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      number = true;
      relativenumbers = true;
      
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
    };

    colorschemes.cattpuccin = {
      enable = true;
      setting.transparent_backgrounds = true;
    };

    plugins = {
      telescope.enable = true;
      treesitter.enable = true;
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
        };
      };
    };
  };

}
