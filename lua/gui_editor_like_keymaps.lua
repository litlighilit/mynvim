
-- Terminal may not send <C-BS> to nvim

vim.keymap.set('i', '<C-BS>', '<C-w>', { noremap = true, desc = "Delete previous word" })

vim.keymap.set('i', '<C-Del>', '<C-o>de', { noremap = true, desc = "Delete next word" })

vim.keymap.set('i', '<C-z>', '<C-o>u', { noremap = true, desc = "undo" })
vim.keymap.set('i', '<C-S-z>', '<C-o><C-r>', { noremap = true, desc = "redo" })

vim.keymap.set('i', '<C-s>', '<C-o>:w<CR>', { noremap = true, desc = "Save file" })
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, desc = "Save file" })

