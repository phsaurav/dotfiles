return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "ob-vault",
					path = "~/obsidian-vault",
				},
			},
			notes_subdir = "inbox",
			new_notes_location = "notes_subdir",
			disable_frontmatter = true,
			mappings = {
				["gf"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
				["<leader>ti"] = {
					action = function()
						return require("obsidian").util.toggle_checkbox()
					end,
					opts = { buffer = true },
				},
			},
			completion = {
				nvim_cmp = false,
				min_chars = 2,
			},

			-- Optional, define your own callbacks to further customize behavior.
			callbacks = {
				-- Runs at the end of `require("obsidian").setup()`.
				---@param client obsidian.Client
				post_setup = function(client) end,

				-- Runs anytime you enter the buffer for a note.
				---@param client obsidian.Client
				---@param note obsidian.Note
				enter_note = function(client, note) end,

				-- Runs anytime you leave the buffer for a note.
				---@param client obsidian.Client
				---@param note obsidian.Note
				leave_note = function(client, note) end,

				-- Runs right before writing the buffer for a note.
				---@param client obsidian.Client
				---@param note obsidian.Note
				pre_write_note = function(client, note) end,

				-- Runs anytime the workspace is set/changed.
				---@param client obsidian.Client
				---@param workspace obsidian.Workspace
				post_set_workspace = function(client, workspace) end,
			},

			ui = {
				enable = true,
				update_debounce = 200,
				max_file_length = 5000,
				checkboxes = {
					[" "] = { char = "☐", hl_group = "ObsidianTodo" },
					["x"] = { char = "☑", hl_group = "ObsidianDone" },
					[">"] = { char = "▶", hl_group = "ObsidianRightArrow" },
					["~"] = { char = "≈", hl_group = "ObsidianTilde" },
					["!"] = { char = "⚠", hl_group = "ObsidianImportant" },
				},
				bullets = { char = "•", hl_group = "ObsidianBullet" },
				external_link_icon = { char = "🔗", hl_group = "ObsidianExtLinkIcon" },
				reference_text = { hl_group = "ObsidianRefText" },
				highlight_text = { hl_group = "ObsidianHighlightText" },
				tags = { hl_group = "ObsidianTag" },
				hl_groups = {
					ObsidianTodo = { bold = true, fg = "#f78c6c" },
					ObsidianDone = { bold = true, fg = "#89ddff" },
					ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
					ObsidianTilde = { bold = true, fg = "#ff5370" },
					ObsidianImportant = { bold = true, fg = "#d73128" },
					ObsidianBullet = { bold = true, fg = "#89ddff" },
					ObsidianRefText = { underline = true, fg = "#c792ea" },
					ObsidianExtLinkIcon = { fg = "#c792ea" },
					ObsidianTag = { italic = true, fg = "#89ddff" },
					ObsidianHighlightText = { bg = "#75662e" },
				},
			},

			attachments = {
				img_folder = "Attachments", -- This is the default

				---@return string
				img_name_func = function()
					-- Prefix image names with timestamp.
					return string.format("%s-", os.time())
				end,

				---@param client obsidian.Client
				---@param path obsidian.Path the absolute path to the image file
				---@return string
				img_text_func = function(client, path)
					path = client:vault_relative_path(path) or path
					return string.format("![%s](%s)", path.name, path)
				end,
			},
		},
		config = function(_, opts)
			require("obsidian").setup(opts)

			local cmp = require("cmp")
			cmp.register_source("obsidian", require("cmp_obsidian").new())
			cmp.register_source("obsidian_new", require("cmp_obsidian_new").new())
			cmp.register_source("obsidian_tags", require("cmp_obsidian_tags").new())

			-- Enable completion menu
			vim.o.completeopt = "menu,menuone,noselect"

			-- Navigate to vault
			vim.keymap.set("n", "<leader>oo", "<Cmd>:cd ~/obsidian-vault<CR>")

			-- Convert note to template and remove leading whitespace
			vim.keymap.set("n", "<leader>on", ":ObsidianTemplate Base<CR> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<CR>")

			-- Strip date from note title and replace dashes with spaces (cursor must be on the title)
			vim.keymap.set("n", "<leader>ot", function()
				vim.cmd([[
        s/\(#\)[A-Za-z]*-[0-9]*-[0-9]*_/\1/
        s/_/ /g
    ]])
			end, { desc = "Strip date and reformat title" })

			vim.keymap.set("n", "<leader>of", function()
				require("telescope.builtin").find_files({
					search_dirs = {
						vim.fn.expand("~/obsidian-vault/Notes"),
						vim.fn.expand("~/obsidian-vault/Inbox/"),
						vim.fn.expand("~/obsidian-vault/Zettelkasten/"),
					},
					prompt_title = "Search Obsidian Notes",
				})
			end, { desc = "Search files in Obsidian Notes" })

			vim.keymap.set("n", "<leader>os", function()
				require("telescope.builtin").live_grep({
					search_dirs = {
						vim.fn.expand("~/obsidian-vault/Notes"),
						vim.fn.expand("~/obsidian-vault/Inbox/"),
						vim.fn.expand("~/obsidian-vault/Zettelkasten/"),
					},
					prompt_title = "Grep Obsidian Notes",
				})
			end, { desc = "Grep content in Obsidian Notes" })

			-- Move file in current buffer to zettelkasten folder
			vim.keymap.set("n", "<leader>ok", function()
				local file_path = vim.fn.expand("%:p")
				local target_dir = vim.fn.expand("~/obsidian-vault/Zettelkasten")
				local target_path = target_dir .. "/" .. vim.fn.fnamemodify(file_path, ":t") -- Append filename to target dir

				-- Check if the target directory exists
				if vim.fn.isdirectory(target_dir) == 0 then
					vim.notify("Target directory does not exist: " .. target_dir, vim.log.levels.ERROR)
					return
				end

				-- Try to move the file
				local result = vim.fn.system({ "mv", file_path, target_path })
				if vim.v.shell_error ~= 0 then
					vim.notify("Failed to move file: " .. result, vim.log.levels.ERROR)
				else
					vim.cmd("bd") -- Close the buffer
					vim.notify("Moved file to Zettelkasten: " .. target_path, vim.log.levels.INFO)
				end
			end, { desc = "Move file to Zettelkasten" })

			-- Delete file in current buffer
			vim.keymap.set("n", "<leader>odd", function()
				local file_path = vim.fn.expand("%:p")
				local confirmation = vim.fn.confirm("Delete file: " .. file_path .. "?", "&Yes\n&No", 2)
				if confirmation == 1 then
					vim.cmd(string.format("silent !rm '%s'", file_path))
					vim.cmd("bd")
					vim.notify("Deleted file: " .. file_path)
				else
					vim.notify("File deletion cancelled.", vim.log.levels.INFO)
				end
			end, { desc = "Delete file in current buffer" })
		end,
	},
}
