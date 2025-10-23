-- lua/utils/replacer.lua
local M = {}

local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO

local function escape_pattern(text)
  return vim.fn.escape(text, [[\#]])
end

local function escape_replacement(text)
  return vim.fn.escape(text, [[\#&]])
end

local function replace_in_buffer(pattern, default_replacement)
  vim.ui.input({
    prompt  = ('Replace "%s" with: '):format(pattern),
    default = default_replacement or pattern,
  }, function(replacement)
    if replacement == nil then
      return
    end
    local escaped_pattern     = escape_pattern(pattern)
    local escaped_replacement = escape_replacement(replacement)
    vim.cmd(string.format([[%%s#\V%s#%s#g]], escaped_pattern, escaped_replacement))
  end)
end

local function capture_visual_selection()
  local mode = vim.fn.visualmode()
  if mode == '\022' then
    return nil, 'Block selections are not supported.'
  end

  -- Save all registers so we can restore later
  local saved = {}
  for _, reg in ipairs({ '"', 's' }) do
    saved[reg] = { vim.fn.getreg(reg), vim.fn.getregtype(reg) }
  end

  -- Yank the selection literally into register s
  vim.cmd('normal! "sy')

  local text = vim.fn.getreg('s')

  -- Restore registers
  for reg, value in pairs(saved) do
    vim.fn.setreg(reg, value[1], value[2])
  end

  if text == '' then
    return nil, 'Empty visual selection.'
  end
  if text:find('\n') then
    return nil, 'Multiline selections are not supported.'
  end

  return text, nil
end

local function with_visual_selection(callback)
  local selection, err = capture_visual_selection()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx',
    false)
  if not selection then
    if err then
      vim.notify(err, WARN)
    end
    return
  end
  vim.schedule(function()
    callback(selection)
  end)
end

-- Public API ---------------------------------------------------------------

function M.replace_word_under_cursor()
  local word = vim.fn.expand('<cWORD>')
  if word == '' then
    vim.notify('No word under cursor.', WARN)
    return
  end
  replace_in_buffer(word, word)
end

function M.replace_visual_selection_in_buffer()
  with_visual_selection(function(selection)
    replace_in_buffer(selection, selection)
  end)
end

-- Project-wide replace -----------------------------------------------------

local search_globs = {}

local function populate_quickfix(pattern)
  if vim.fn.executable('rg') ~= 1 then
    vim.notify('ripgrep (rg) is required for project-wide replacements.', WARN)
    return false
  end

  local cmd = { 'rg', '--vimgrep', '--no-heading', '--smart-case', '--fixed-strings' }
  for _, glob in ipairs(search_globs) do
    table.insert(cmd, '--glob=' .. glob)
  end
  table.insert(cmd, pattern)
  table.insert(cmd, '.')

  local results = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 or #results == 0 then
    vim.notify(('No matches found for "%s".'):format(pattern), WARN)
    return false
  end

  vim.fn.setqflist({}, ' ', { title = ('Replace "%s"'):format(pattern), lines = results })
  return true
end

function M.replace_visual_selection_projectwide()
  with_visual_selection(function(selection)
    vim.ui.input({
      prompt  = ('Replace "%s" with: '):format(selection),
      default = selection,
    }, function(replacement)
      if replacement == nil then
        return
      end
      if selection == replacement then
        vim.notify('Search text and replacement are identical; nothing to do.', WARN)
        return
      end

      if not populate_quickfix(selection) then
        return
      end

      vim.cmd('copen')
      vim.notify(
        'Review matches in the quickfix list. During the prompt, press y/n per match, or a toaccept all remaining.',
        INFO
      )

      if vim.fn.confirm('Run project-wide replacement now?', '&Yes\n&No', 1) ~= 1 then
        return
      end

      local escaped_pattern     = escape_pattern(selection)
      local escaped_replacement = escape_replacement(replacement)
      vim.cmd(string.format([[cdo %%s#\V%s#%s#gc | update]], escaped_pattern,
        escaped_replacement))
      vim.cmd('copen') -- refresh quickfix to show what changed
    end)
  end)
end

return M
