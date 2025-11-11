--[ int. fugitive with git-flow
--]

local M = {}

local function wrap(autocmd, cb)
  vim.api.nvim_create_autocmd("User", {
    pattern = autocmd,
    callback = cb,
  })
end
local gitLogCmd = [[<cmd>Flog -format=%h\ %<(64,trunc)%s%ad -date=format:%y-%m-%d\ %H:%M<CR>]]

local buf_map = vim.api.nvim_buf_set_keymap
function M.setup(mapFlog, mapRet)
  vim.keymap.set("n", mapFlog, gitLogCmd, {})
  wrap("FugitiveIndex", function()
      -- the subject limits to 50 chars
      -- datetime len: 14
      buf_map(0, "n", mapFlog, gitLogCmd, {})
      buf_map(0, "n", mapRet,  [[gq]], {noremap = false,})  -- fugitive hooks gq
    end
  )
  wrap("FlogUpdate", function()
      buf_map(0, "n", mapFlog, [[gq]], {noremap = false,})
    end
  )
end

return M

