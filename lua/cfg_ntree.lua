

local api = require("nvim-tree.api")
-- Automatically open file upon creation
api.events.subscribe(api.events.Event.FileCreated, function(file)
  vim.cmd("edit " .. vim.fn.fnameescape(file.fname))
end)


local Path = require('plenary.path')
local tree = api.tree

-- sync tree with opened file
local function open_nvim_tree(data, current_window)
  --XXX:TODO: `nvim +n xxx`'s +n just targets to nvim-tree instead of `xxx` file
  local fp = data.file
  local bo = vim.bo[data.buf]

  if vim.fn.filereadable(fp) == 0 or
      bo.buftype ~= "" or -- not a normal buffer (not related to a file)
      bo.filetype == "git" -- e.g. git-flog's tmp file
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
  })]]--
  tree.find_file{buf=fp, open=true,
    focus=false, current_window=current_window, -- XXX: a single focus=false doesn't work
    update_root=true,
  }
end

local OpenTreeEvent  = "BufEnter"
vim.api.nvim_create_autocmd(OpenTreeEvent, {callback=function (data)
  open_nvim_tree(data, true)
  tree.close()
  vim.api.nvim_del_autocmd(data.id)
  vim.api.nvim_create_autocmd(OpenTreeEvent, {callback=function (args)
    -- don't open tree if it's closed manually
    if not tree.is_visible{any_tabpage=true} then return end
    open_nvim_tree(args, false)
  end})
end})

-- Make :bd and :q behave as usual when tree is visible
vim.api.nvim_create_autocmd({'BufEnter', 'QuitPre'}, {
  nested = false,
  callback = function(e)
    -- Nothing to do if tree is not opened
    if not tree.is_visible() then
      return
    end

    -- How many focusable windows do we have? (excluding e.g. incline status window)
    local winCount = 0
    for _,winId in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(winId).focusable then
        winCount = winCount + 1
      end
    end

    -- We want to quit and only one window besides tree is left
    if e.event == 'QuitPre' and winCount == 2 then
      vim.api.nvim_cmd({cmd = 'qall'}, {})
    end

    -- :bd was probably issued an only tree window is left
    -- Behave as if tree was closed (see `:h :bd`)
    if e.event == 'BufEnter' and winCount == 1 then
      -- Required to avoid "Vim:E444: Cannot close last window"
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last buffer used before closing
        tree.toggle({find_file = true, focus = true})
        -- re-open nivm-tree
        tree.toggle({find_file = true, focus = false})
      end, 10)
    end
  end
})

