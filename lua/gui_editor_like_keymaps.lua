
-- Terminal may not send <C-BS> to nvim

local function is_whitespace(ch)
  return ch == ' ' or ch == '\t'
end

-- Move to the start of the next word, but never cross the end of the line.
local function word_right_in_line()
  local lnum = vim.fn.line('.')
  local ccol = vim.fn.charcol('.')
  local text = vim.fn.getline('.')
  local len = vim.fn.strchars(text)
  local i = ccol - 1

  if i >= len then
    return
  end

  local function char_at(j)
    return vim.fn.strcharpart(text, j, 1)
  end

  while i < len and not is_whitespace(char_at(i)) do
    i = i + 1
  end
  while i < len and is_whitespace(char_at(i)) do
    i = i + 1
  end

  vim.fn.setcursorcharpos(lnum, i + 1)
end

vim.keymap.set('i', '<C-Right>', word_right_in_line, { noremap = true, desc = "Move to next word (stay on line)" })

vim.keymap.set('i', '<C-BS>', '<C-w>', { noremap = true, desc = "Delete previous word" })

vim.keymap.set('i', '<C-Del>', '<C-o>de', { noremap = true, desc = "Delete next word" })

vim.keymap.set('i', '<C-z>', '<C-o>u', { noremap = true, desc = "undo" })
vim.keymap.set('i', '<C-S-z>', '<C-o><C-r>', { noremap = true, desc = "redo" })

vim.keymap.set('i', '<C-s>', '<C-o>:w<CR>', { noremap = true, desc = "Save file" })
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, desc = "Save file" })

