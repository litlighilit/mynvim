local servers = require('lsp-setup').servers
for _, name in ipairs(servers) do
  assert(vim.lsp.config[name], 'Missing LSP config: ' .. name)
end
assert(vim.lsp.config.pyright.settings.python.analysis.typeCheckingMode == 'basic')
assert(vim.lsp.config.rust_analyzer.settings['rust-analyzer'].check.command == 'check')
assert(vim.fn.executable('pyright-langserver') == 1, 'Mason bin directory is not on PATH')
assert(vim.fn.maparg('<leader>fd', 'n'):find('Telescope diagnostics', 1, true))

local root = vim.fn.tempname()
vim.fn.mkdir(root .. '/.venv/bin', 'p')
vim.fn.writefile({ '#!/bin/sh' }, root .. '/.venv/bin/python')
vim.fn.setfperm(root .. '/.venv/bin/python', 'rwx------')
local config = { root_dir = root, settings = { python = {} } }
vim.lsp.config.pyright.before_init({}, config)
assert(config.settings.python.pythonPath == root .. '/.venv/bin/python')
vim.fn.delete(root, 'rf')

local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_exec_autocmds('LspAttach', { buffer = buf, data = { client_id = -1 } })
vim.api.nvim_buf_call(buf, function()
  assert(vim.fn.maparg('<leader>rn', 'n', false, true).buffer == 1)
  assert(vim.fn.maparg('<leader>ca', 'n', false, true).buffer == 1)
end)
vim.api.nvim_buf_delete(buf, { force = true })
