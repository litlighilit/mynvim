-- Run from this repository: nvim --headless -i NONE -c 'luafile tests/run.lua'
local function run()
local ok, err = xpcall(function()
  assert(vim.v.errmsg == '', 'Startup error: ' .. vim.v.errmsg)
  for _, file in ipairs(vim.fn.glob('tests/test_*.lua', false, true)) do
    dofile(file)
    print('PASS ' .. file)
  end
end, debug.traceback)
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd('cquit 1')
else
  vim.cmd('qa!')
end
end

-- Which-key initializes after VimEnter; exercise the real startup lifecycle.
if vim.v.vim_did_enter == 1 then
  vim.schedule(run)
else
  vim.api.nvim_create_autocmd('VimEnter', { once = true, callback = function() vim.schedule(run) end })
end
