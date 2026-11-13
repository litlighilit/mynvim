--[ int. fugitive with git-flow
--]

local M = {}

local function wrap(autocmd, cb)
  vim.api.nvim_create_autocmd("User", {
    pattern = autocmd,
    callback = cb,
  })
end
local gitLogCmd = [[<cmd>Flog -format=%h\ %<(64,trunc)%s%ad\ \ %an -date=format:%y-%m-%d\ %H:%M<CR>]]

local buf_map = vim.api.nvim_buf_set_keymap

-- as gitsign.stash_buffer does not work for untracked file,
--  I often need to type `:G add %`,
--  so I simplify it as `:Gadd` here
vim.api.nvim_create_user_command('Gadd', function (opts)
  local args = opts.args
  if args == "" or args == "-f" then
    args = args .. " %"
  end
  vim.cmd('Git add ' .. args)
end, { nargs = '*', complete = 'file' } )

function M.setup(mapFlog, mapRet)
  vim.keymap.set("n", mapFlog, gitLogCmd, {})
  wrap("FugitiveIndex", function()
      -- the subject limits to 50 chars
      -- datetime len: 14
      buf_map(0, "n", mapFlog, gitLogCmd, {})
      buf_map(0, "n", mapRet,  [[gq]], {})  -- fugitive hooks gq
      buf_map(0, "n", "<TAB>",  "1p", {})  -- fugitive hooks 1p
    end
  )
  wrap("FlogUpdate", function()
      buf_map(0, "n", mapFlog, [[gq]], {})
    end
  )
end

return M

