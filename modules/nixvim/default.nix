{ lib, config, ... } : {
	options = {
		modules.nixvim.enable = lib.mkEnableOption "Enables Nix driven Neovim configuration";
	};

	config = lib.mkIf config.modules.nixvim.enable {
		programs.nixvim = {
			enable = true;
			defaultEditor = true;

			opts = {
			 	number = true;
				relativenumber = true;

				shiftwidth = 2;
				tabstop = 2;
			};

			colorschemes.catppuccin = {
				enable = true;
				settings.transparent_background = true;
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
	};
}
