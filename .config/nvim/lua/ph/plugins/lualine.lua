return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function get_relative_file_path()
      -- Find the project root using .git or fallback to cwd
      local root = vim.fn.finddir(".git/..", vim.fn.getcwd() .. ";")  -- Try .git first
      if root == "" then
        root = vim.fn.finddir(".obsidian/..", vim.fn.getcwd() .. ";") -- Try .obsidian next
      end
      if root == "" then
        root = vim.fn.getcwd() -- Fallback if no root is found
      end

      -- Get the absolute path of the current file
      local file_path = vim.fn.expand("%:p")
      if file_path == "" then
        return "" -- No file is currently open
      end

      -- Ensure the root ends with a slash for consistency
      if not root:match("/$") then
        root = root .. "/"
      end

      -- Strip the root from the file path to make it relative
      local relative_path
      if file_path:sub(1, #root) == root then
        relative_path = file_path:sub(#root + 1)
      else
        -- If the file is outside the root, return the full path
        return file_path
      end

      -- Split the relative path into components
      local path_components = {}
      for component in string.gmatch(relative_path, "[^/]+") do
        table.insert(path_components, component)
      end

      -- Keep only up to 3 levels deep
      if #path_components > 4 then
        return "../" .. table.concat(path_components, "/", #path_components - 3, #path_components)
      else
        return relative_path
      end
    end

    local custom_ayu = require("lualine.themes.ayu")
    local codecompanion_spinner = require("ph.utils.spinner")

    local function codecompanion_current_model_name()
      local chat = require("codecompanion").buf_get_chat(vim.api.nvim_get_current_buf())
      return chat and chat.settings.model
    end

    custom_ayu.normal.c.bg = nil
    custom_ayu.normal.b.bg = "#1C1C1C"
    custom_ayu.normal.a.bg = "#5FD7D7"

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = custom_ayu,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          {
            "buffers",
            hide_filename_extension = false,
            buffers_color = {
              active = { bg = nil, fg = "#FFD173" },
              inactive = { bg = nil },
            },
            max_length = vim.o.columns / 3,
            symbols = {
              alternate_file = "*", -- Symbol for alternate file
            },
          }
        },
        lualine_x = { get_relative_file_path, "fileformat",
          "filetype",
          -- "tabnine"
        },
        lualine_y = { codecompanion_current_model_name, "progress" },
        lualine_z = { codecompanion_spinner, "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          "filename",
          function()
            return require("auto-session.lib").current_session_name(true)
          end,
        },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
