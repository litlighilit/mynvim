

local api = require("nvim-tree.api")
-- Automatically open file upon creation
api.events.subscribe(api.events.Event.FileCreated, function(file)
  vim.cmd("edit " .. vim.fn.fnameescape(file.fname))
end)


local Path = require('plenary.path')
local tree = api.tree

local function buf_not_against_real_file(bo)
  return bo.buftype ~= "" or -- not a normal buffer (not related to a file)
      bo.filetype == "git" -- e.g. git-flog's tmp file
end
-- sync tree with opened file
local function open_nvim_tree(data, open)
  --XXX:TODO:the following line not work as data.buf is always file's over tree_buf's
  if tree.is_tree_buf(data.buf) then return end

  local fp = data.file

  if vim.fn.filereadable(fp) == 0 or buf_not_against_real_file(vim.bo[data.buf])
    then return
  end
  -- if is xxx/.git/xxx, e.g. COMMIT_MSG
  local path = Path:new(fp)
  local ds = path:parent().filename
  local last2 = vim.fn.fnamemodify(ds, ':t')
  if last2 == ".git" then return end
  -- open the tree, find the file but don't focus it
  --[[ cannot work: just open tree without sync but focus on it
  tree.open({ focus = false, 
  path = fp,
    update_root=true,
  })
  ]]--
  tree.find_file{buf=fp, open=open,
    focus=false,
    update_root=true,
  }
end

local OpenTreeEvent = "BufEnter"
vim.api.nvim_create_autocmd(OpenTreeEvent, {callback=function (data)
  open_nvim_tree(data, false)  -- TODO: make open=true here (once open, cannot re-focus previous window)

  vim.api.nvim_del_autocmd(data.id)
  vim.api.nvim_create_autocmd(OpenTreeEvent, {callback=function (args)
    -- don't open tree if it's closed manually
    if not tree.is_visible{any_tabpage=true} then return end
    open_nvim_tree(args, true)
  end})
end})

-- Make :q behave as usual when tree is visible
vim.api.nvim_create_autocmd("QuitPre", {callback = function() tree.close() end})
-- TODO: handle `:bd`

