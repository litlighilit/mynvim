
-- Terminal may not send <C-BS> to nvim

vim.keymap.set('i', '<C-BS>', '<C-w>', { noremap = true, desc = "Delete previous word" })

vim.keymap.set('i', '<C-Del>', '<C-o>dw<Del>', { noremap = true, desc = "Delete next word" })


