
-- Terminal may not send <C-BS> to nvim

vim.keymap.set('i', '<C-BS>', '<C-w>', { noremap = true, desc = "Delete previous word" })

vim.keymap.set('i', '<C-Del>', '<C-o>de', { noremap = true, desc = "Delete next word" })

--vim.keymap.set('i', '<C-Z>', '<C-o>u', { noremap = true, desc = "undo" })
--vim.keymap.set('i', '<C-S-Z>', '<C-o><C-R>', { noremap = true, desc = "redo" })

