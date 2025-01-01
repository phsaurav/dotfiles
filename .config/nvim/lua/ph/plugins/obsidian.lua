return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },

    opts = {}, -- Default options for render-markdown
    config = function()
      -- -- Safely disable Obsidian UI if it exists
      require("render-markdown").setup({
        code = {
          border = 'none',
        }
      })

      -- Clear the namespace only if it exists
      local obsidian_ns_id = vim.api.nvim_get_namespaces()["ObsidianUI"]
      if obsidian_ns_id then
        vim.api.nvim_buf_clear_namespace(0, obsidian_ns_id, 0, -1)
      end

      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*.md",           -- This is supposed to match only Markdown files
        callback = function()
          vim.cmd("RenderMarkdown") -- Automatically render Markdown
        end,
      })
    end,
  },
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
          path =
          "/Users/phsaurav/Library/CloudStorage/GoogleDrive-phsaurav29@gmail.com/My Drive/[01] My_Folder/[04] Education/Obsidian-Vault",
        },
      },
      notes_subdir = "inbox",
      new_notes_location = "notes_subdir",
      disable_frontmatter = true,
      templates = {
        subdir = "Templates",
        date_format = "%d-%m-%Y",
        time_format = "%H:%M",
      },
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
      vim.keymap.set("n", "<leader>on", function()
        -- Save the current cursor position
        local current_pos = vim.api.nvim_win_get_cursor(0)

        -- Move cursor to the beginning of the file
        vim.cmd("normal! gg")

        -- Try to apply the template
        local success, result = pcall(function()
          vim.cmd("ObsidianTemplate Base")
        end)

        if not success then
          vim.notify("Failed to apply template: " .. tostring(result), vim.log.levels.ERROR)
          return
        end

        -- Remove leading whitespace more safely
        vim.cmd([[
    let save_cursor = getpos(".")
    silent! keeppatterns %s/\%^\n\+//e
    call setpos('.', save_cursor)
  ]])

        -- Restore the cursor position
        vim.api.nvim_win_set_cursor(0, current_pos)

        vim.notify("Note converted to template and leading whitespace removed", vim.log.levels.INFO)
      end, { desc = "Convert note to template and remove leading whitespace" })


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
