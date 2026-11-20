local cmp = require('cmp')
local found = false
for _, source in ipairs(cmp.get_config().sources) do
  found = found or source.name == 'luasnip'
end
assert(found, 'LuaSnip source missing')
assert(#vim.api.nvim_get_runtime_file('snippets/python/python.json', true) > 0,
  'friendly-snippets templates missing')

local ls = require('luasnip')
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_current_buf(buf)
ls.lsp_expand('hello ${1:world} $0')
assert(vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == 'hello world ')
assert(ls.locally_jumpable(1), 'Snippet placeholder should allow a forward jump')
ls.jump(1)
ls.unlink_current()
vim.api.nvim_buf_delete(buf, { force = true })
