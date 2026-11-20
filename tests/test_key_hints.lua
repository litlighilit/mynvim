local config = require('which-key.config')
assert(config.options.delay == 300)
assert(config.options.preset == 'classic')
local found = false
for _, mapping in ipairs(config.mappings) do
  if mapping.lhs == '<leader>f' then found = true end
end
assert(found, 'Which-key search group missing')
assert(vim.fn.maparg('<leader>e', 'n'):find('NvimTreeFindFileToggle', 1, true))
assert(vim.fn.maparg('<leader>fg', 'n', false, true).desc == 'Telescope live search commits')
for _, trigger in ipairs(config.options.triggers) do
  assert(not trigger.mode:find('[it]'), 'Hints must not capture insert/terminal input')
end
