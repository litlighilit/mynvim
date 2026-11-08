--[[
-- dispite its name, currently it implements only one functionality:
-- `:[<n>]T`: switch to (create or hide or show) terminal with id <n>
--
-- (mostly, just simple combination of `:ToggleTerm` followed by `:<n>ToggleTerm`
--
-- It's easy to note as long as there aren't many terminals,
--   this implementation is the most effective (that's, useful and easy to implement)
--
-- XXX: I've tried to remap C-PageUp/Down on terminal mode,
--   but in GUI termainal, where we know C-PageUp/Down are used to nav terminal app's tab.
--   C-S-PageUp/Down does nothing but inserting a `6~`
--   so such keymaps cannot be implemented.
--]]
local toggleterm = require("toggleterm")
local terms = require("toggleterm.terminal")

local function switch_or_create_terminal(count)
  local last_id = terms.get_focused_id()
  local is_focused = last_id ~= nil
  if is_focused then
    toggleterm.toggle(last_id)  -- close previous one
  end
  if count == 0 then count = terms.next_id() end
  toggleterm.toggle(count)
end

vim.api.nvim_create_user_command(
  "T",
  function (opts) switch_or_create_terminal(opts.count) end,
  { count = true, }
)

