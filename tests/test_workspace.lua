local workspaces = require('workspaces')
local root, cwd = vim.fn.tempname(), vim.fn.getcwd()
vim.fn.mkdir(root, 'p')
workspaces.setup({ path = root .. '/workspaces', notify_info = false })
workspaces.add(root, 'regression-workspace')
local buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_set_current_buf(buf)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'unsaved work' })
vim.bo[buf].modified = true
local notify, warnings = vim.notify, {}
vim.notify = function(message) table.insert(warnings, message) end
workspaces.open('regression-workspace')
vim.notify = notify
assert(vim.api.nvim_buf_is_valid(buf), 'Workspace switching discarded unsaved work')
assert(vim.bo[buf].modified)
assert(vim.fn.getcwd() == cwd, 'Workspace changed despite an unsaved buffer')
assert(#warnings > 0, 'User must be told why switching was blocked')
vim.api.nvim_buf_delete(buf, { force = true })
workspaces.setup({ path = vim.fn.stdpath('data') .. '/workspaces', notify_info = true })
vim.fn.delete(root, 'rf')
