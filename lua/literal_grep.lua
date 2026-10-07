local M = {}

-- I do not use the live-grep-args shortcut here as it relies on the -F postfix.
-- Escape regex metacharacters instead so the search remains literal without -F.
local tele_live_grep = require('telescope').extensions.live_grep_args

local function grep_literal(value)
  value = vim.fn.escape(value, [[\.^$*+?()[]{}|]])
  tele_live_grep.live_grep_args({
    default_text = value,
  })
end

function M.word()
  grep_literal(vim.fn.expand('<cword>'))
end

function M.visual()
  local _, start_line, start_col = unpack(vim.fn.getpos('v'))
  local _, end_line, end_col = unpack(vim.fn.getpos('.'))
  start_line, end_line = math.min(start_line, end_line), math.max(start_line, end_line)
  start_col, end_col = math.min(start_col, end_col), math.max(start_col, end_col)
  local text = vim.api.nvim_buf_get_text(0, start_line - 1, start_col - 1, end_line - 1, end_col, {})
  grep_literal(text[1] or '')
end

return M
