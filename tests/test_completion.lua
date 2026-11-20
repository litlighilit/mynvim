local cmp = require('cmp')
local config = cmp.get_config()
local names = {}
for _, source in ipairs(config.sources) do names[source.name] = true end
for _, name in ipairs({ 'nvim_lsp', 'path', 'buffer' }) do
  assert(names[name], 'Missing completion source: ' .. name)
end
assert(config.mapping['<Tab>'] and config.mapping['<S-Tab>'])
assert(vim.lsp.config.pyright.capabilities.textDocument.completion.completionItem.snippetSupport)
local ft = vim.bo.filetype
vim.bo.filetype = 'nim'
assert(not config.enabled(), 'Nim must keep its original completion engine')
vim.bo.filetype = 'python'
assert(config.enabled())
vim.bo.filetype = ft
