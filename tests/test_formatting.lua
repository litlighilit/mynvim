local conform = require('conform')
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_current_buf(buf)
vim.bo[buf].buftype = ''
vim.bo[buf].filetype = 'python'
local names = {}
for _, formatter in ipairs(conform.list_formatters(buf)) do
  assert(formatter.available, formatter.name .. ' is unavailable')
  table.insert(names, formatter.name)
end
assert(vim.deep_equal(names, { 'ruff_organize_imports', 'ruff_format' }))
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
  'import sys', 'import os', '', 'print( os.name,sys.version )',
})
local file = vim.fn.tempname() .. '.py'
vim.cmd('write ' .. vim.fn.fnameescape(file))
local actual = vim.fn.readfile(file)
assert(vim.deep_equal(actual, {
  'import os', 'import sys', '', 'print(os.name, sys.version)',
}), 'Save did not organize imports and format: ' .. vim.inspect(actual))
assert(vim.fn.maparg('<leader>cf', 'n', false, true).desc == 'Format code')
vim.api.nvim_buf_delete(buf, { force = true })
vim.fn.delete(file)
