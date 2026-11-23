local M = {}

local function grep_literal(value)
  -- The builtin picker passes the pattern after --, so leading dashes and
  -- quotes cannot turn selected text into ripgrep arguments.
  value = vim.fn.escape(value, [[\.^$*+?()[]{}|]])
  local multiline = value:find('\n', 1, true) ~= nil
  value = value:gsub('\n', [[\n]])
  require('telescope.builtin').live_grep({
    default_text = value,
    additional_args = multiline and { '--multiline' } or {},
  })
end

function M.word()
  grep_literal(vim.fn.expand('<cword>'))
end

function M.visual()
  local text = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), {
    type = vim.fn.mode(),
    exclusive = vim.o.selection == 'exclusive',
  })
  grep_literal(table.concat(text, '\n'))
end

return M
