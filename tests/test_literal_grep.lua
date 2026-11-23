local builtin = require('telescope.builtin')
local old_builtin = builtin.live_grep
local captured
local function capture(opts) captured = opts end
builtin.live_grep = capture
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_current_buf(buf)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'abcdefghij', 'klmnopqrst' })
vim.api.nvim_win_set_cursor(0, { 1, 7 })
vim.cmd('normal! v')
vim.api.nvim_win_set_cursor(0, { 2, 2 })
require('literal_grep').visual()
vim.cmd('normal! ' .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true))
assert(captured.default_text == [[hij\nklm]], 'Multiline selection was truncated or reordered: ' .. vim.inspect(captured.default_text))
assert(vim.tbl_contains(captured.additional_args, '--multiline'))

vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '甲乙丙' })
vim.api.nvim_win_set_cursor(0, { 1, 3 })
vim.cmd('normal! v')
require('literal_grep').visual()
vim.cmd('normal! ' .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true))
assert(captured.default_text == '乙', 'Selection split a UTF-8 character: ' .. vim.inspect(captured.default_text))
builtin.live_grep = old_builtin
vim.api.nvim_buf_delete(buf, { force = true })
