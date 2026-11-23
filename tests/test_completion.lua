local cmp = require('cmp')
local config = cmp.get_config()
local names = {}
for _, source in ipairs(config.sources) do names[source.name] = true end
for _, name in ipairs({ 'nvim_lsp', 'path', 'buffer' }) do
  assert(names[name], 'Missing completion source: ' .. name)
end
assert(config.mapping['<Tab>'] and config.mapping['<S-Tab>'])
local keymap = require('cmp.utils.keymap')
local ctrl_n
for key, mapping in pairs(config.mapping) do
  assert(not keymap.equals(key, '<C-Space>') and not keymap.equals(key, '<C-@>'),
    'Completion must leave the input method shortcut unbound')
  if keymap.equals(key, '<C-n>') then ctrl_n = mapping.i end
end
assert(ctrl_n, 'Ctrl-n completion mapping missing')
local complete, visible = cmp.complete, cmp.visible
local requested = false
cmp.complete = function() requested = true end
cmp.visible = function() return false end
ctrl_n()
cmp.complete, cmp.visible = complete, visible
assert(requested, 'Ctrl-n should request completion when the menu is closed')
assert(vim.lsp.config.pyright.capabilities.textDocument.completion.completionItem.snippetSupport)
local ft = vim.bo.filetype
vim.bo.filetype = 'nim'
assert(not config.enabled(), 'Nim must keep its original completion engine')
vim.bo.filetype = 'python'
assert(config.enabled())
vim.bo.filetype = ft
