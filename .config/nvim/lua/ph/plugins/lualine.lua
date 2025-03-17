return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function get_relative_file_path()
      local root = vim.fn.finddir(".git/..", vim.fn.getcwd() .. ";")
      if root == "" then
        root = vim.fn.finddir(".obsidian/..", vim.fn.getcwd() .. ";")
      end
      if root == "" then
        root = vim.fn.getcwd()
      end

      local file_path = vim.fn.expand("%:p")
      if file_path == "" then
        return ""
      end

      if not root:match("/$") then
        root = root .. "/"
      end

      local relative_path
      if file_path:sub(1, #root) == root then
        relative_path = file_path:sub(#root + 1)
      else
        return file_path
      end

      local path_components = {}
      for component in string.gmatch(relative_path, "[^/]+") do
        table.insert(path_components, component)
      end

      if #path_components > 4 then
        return "../" .. table.concat(path_components, "/", #path_components - 3, #path_components)
      else
        return relative_path
      end
    end

    local custom_ayu = require("lualine.themes.ayu")

    local codecompanion_spinner = require("ph.utils.spinner")

    local function codecompanion_current_model_name()
      if vim.g.codecompanion_in_use then
        local status, codecompanion = pcall(require, "codecompanion")
        if status and codecompanion and type(codecompanion.buf_get_chat) == "function" then
          local chat = codecompanion.buf_get_chat(vim.api.nvim_get_current_buf())
          if chat and chat.settings then
            return chat.settings.model or ""
          end
        end
      end
      return ""
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
              alternate_file = "*",
            },
          },
        },
        lualine_x = { get_relative_file_path, "fileformat", "filetype" },
        lualine_y = {
          codecompanion_current_model_name, "progress" },
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
