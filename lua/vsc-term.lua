--[[
-- dispite its name, currently it implements only one functionality:
-- `:[<n>]T`: switch to (create or hide or show) terminal with id <n>
--
-- XXX: I've tried to remap C-PageUp/Down on terminal mode,
--   but in GUI termainal, where we know C-PageUp/Down are used to nav terminal app's tab.
--   C-S-PageUp/Down does nothing but inserting a `6~`
--   so such keymaps cannot be implemented.
--]]
local M = {}
local toggleterm = require("toggleterm")
local terms = require("toggleterm.terminal")

local function switch_or_create_terminal(count)
  local last_id = terms.get_focused_id()
  if count == 0 then count = terms.next_id() end
  -- Let toggleterm hide an already-focused target, rather than hiding and
  -- immediately reopening it.
  if last_id and last_id ~= count then terms.get(last_id):close() end
  toggleterm.toggle(count)
end

vim.api.nvim_create_user_command(
  "T",
  function (opts) switch_or_create_terminal(opts.count) end,
  { count = true, }
)

-- gt / gT: cycle through terminals (next / previous, wrapping)
local function cycle_terminal(dir)
  local count = vim.v.count
  local all = terms.get_all()
  local n = #all
  if n <= 1 then return end

  local focused_id = terms.get_focused_id()
  local idx
  for i, term in ipairs(all) do
    if term.id == focused_id then idx = i; break end
  end
  if not idx then return end
  local focused = all[idx]
  local function switch_to(term)
    if term.id == focused_id then return end
    -- get_all() returns a dense array, not a table indexed by terminal ID.
    focused:close()
    term:open()
  end

  if count ~= 0 then
    if count < 1 or count > n then return end
    switch_to(all[count])
    return
  end

  -- to next id
  idx = idx + dir
  idx = ((idx-1) % n) + 1  -- reduce to 1..n
  switch_to(all[idx])
end

local function on_open(term)
  local function mapn(k, cb, desc)
    vim.keymap.set("n", k, cb, { buffer = term.bufnr, desc = desc })
  end
  mapn('gt', function() cycle_terminal( 1) end, "Next terminal")
  mapn('gT', function() cycle_terminal(-1) end, "Previous terminal")
  mapn('<C-T>', function() switch_or_create_terminal(0) end, "New terminal")
end

local opt = {
  winbar = {
    enabled = true,
  },
}

local function merge_table(first_table, second_table)
  for k,v in pairs(second_table) do first_table[k] = v end
end
function M.setup(toggletermOpt)
  local final_on_open = on_open
  local new_on_open = toggletermOpt.on_open
  if new_on_open ~= nil then
    final_on_open = function (term)
      on_open(term)
      new_on_open(term)
    end
  end
  toggletermOpt.on_open = final_on_open
  merge_table(opt, toggletermOpt)
  toggleterm.setup(opt)
end
return M
