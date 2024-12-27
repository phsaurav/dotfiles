return {
	"justinmk/vim-sneak",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Sneak settings
		vim.g["sneak#label"] = 1
		vim.g["sneak#s_next"] = 1
		vim.g["sneak#use_ic_scs"] = 1
		vim.g["sneak#prompt"] = "🔎"

		-- Rebind keys for Sneak
		vim.api.nvim_set_keymap("n", "T", "<Plug>Sneak_,", {})
		vim.api.nvim_set_keymap("n", "t", "<Plug>Sneak_;", {})

		-- Set highlight groups
		vim.cmd([[
          highlight Sneak guifg=black guibg=#00C7DF ctermfg=black ctermbg=cyan
          highlight SneakScope guifg=red guibg=yellow ctermfg=red ctermbg=yellow
        ]])
	end,
}
