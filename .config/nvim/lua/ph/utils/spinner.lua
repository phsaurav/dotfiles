local M = require("lualine.component"):extend()

M.processing = false
M.spinner_index = 1

local spinner_symbols = {
  "⢹", -- U+28B9
  "⢺", -- U+28BA
  "⢻", -- U+28BB
  "⢼", -- U+28BC
  "⣏", -- U+28CF
  "⣟", -- U+28DF
  "⣯", -- U+28EF
  "⣷", -- U+28FF
}
local spinner_symbols_len = #spinner_symbols

-- Initializer
function M:init(options)
  M.super.init(self, options)

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", { clear = true })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(event)
      if event.match == "CodeCompanionRequestStarted" then
        self.processing = true
      elseif event.match == "CodeCompanionRequestFinished" then
        self.processing = false
      end
      require("lualine").refresh()
    end,
  })
end

-- Function that runs every time statusline is updated
function M:update_status()
  if self.processing then
    self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
    return spinner_symbols[self.spinner_index]
  else
    return nil
  end
end

return M
