return {
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets", "saghen/blink.compat" },

		version = "*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config

		opts = {
			keymap = {
				preset = "default",
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				-- ["<Tab>"] = { "select_next", "fallback" },
				-- ["<S-Tab>"] = { "select_prev", "fallback" },
			},
			completion = {
				ghost_text = {
					enabled = false,
				},
				menu = {
					winblend = 20,
					scrollbar = false,
				},
				documentation = {
					auto_show = true,
					window = {
						winblend = 20,
						scrollbar = true,
					},
				},
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "obsidian", "obsidian_new", "obsidian_tags" },
				providers = {
					obsidian = {
						name = "obsidian",
						module = "blink.compat.source",
					},
					obsidian_new = {
						name = "obsidian_new",
						module = "blink.compat.source",
					},
					obsidian_tags = {
						name = "obsidian_tags",
						module = "blink.compat.source",
					},
				}, -- optionally disable cmdline completions
				-- cmdline = {},
			},

			signature = {
				enabled = true,
				window = {
					winblend = 20,
					scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
				},
			},
		},
	},
}
