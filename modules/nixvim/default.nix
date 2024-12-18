{ lib, config, ... } : {
	options = {
		modules.nixvim.enable = lib.mkEnableOption "Enables Nix driven Neovim configuration";

		modules.nixvim.theme = lib.mkOption {
			type = lib.types.enum ["gruvbox" "carbonfox" "duskfox"];
			default = "carbonfox";
		};
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

			# Gruvbox
			colorschemes.gruvbox.enable = lib.mkIf (config.modules.nixvim.theme == "gruvbox") true;

			# Nightfox
			colorschemes.nightfox = lib.mkIf (config.modules.nixvim.theme == "carbonfox" || config.modules.nixvim.theme == "duskfox") {
				enable = true;
				flavor = config.modules.nixvim.theme;
			};
			
			extraConfigLuaPost = ''
				vim.api.nvim_set_hl(0, 'LineNr', { fg='#F0F0F0', bold=true })
				vim.api.nvim_set_hl(0, 'Comment', { fg='#CCA000', bold=true })
				vim.api.nvim_set_hl(0, "Normal", { guibg=NONE, ctermbg=NONE })
			'';

			plugins = {
				telescope = {
					enable = true;
					keymaps = {
						"<leader>f" = "find_files";
					};
				};
				treesitter.enable = true;

				lsp = {
					enable = true;
					servers = {
						nixd.enable = true;
						csharp-ls.enable = true;	
						zls.enable = true;
					};
				};

				cmp = {
					enable = true;
					autoEnableSources = true;
					
					settings.sources = [
						{ name = "nvim_lsp"; }
						{ name = "path"; }
						{ name = "buffer"; }
					];
					
					settings.mapping = {
						"<Tab>" = "cmp.mapping.confirm({ select = true })";
						"<S-Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
					};

					settings.snippet.expand = ''
						function(args)
							require('snippy').expand_snippet(args.body)
						end
					'';
				};
				cmp-snippy.enable = true;
			};
		};
	};
}
