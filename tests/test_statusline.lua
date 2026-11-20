assert(vim.o.statusline:find('FugitiveStatusline()', 1, true), 'Git statusline was never configured')
local rendered = vim.api.nvim_eval_statusline(vim.o.statusline, {})
assert(type(rendered.str) == 'string')
