
-- ## python
-- vim.g.loaded_python3_provider=1

local Plug = vim.fn['plug#']

-- ## nim
Plug 'alaviss/nim.nvim'
vim.opt.foldenable = false

Plug 'prabirshrestha/asyncomplete.vim'
vim.cmd [[
au User asyncomplete_setup call asyncomplete#register_source({
    \ 'name': 'nim',
    \ 'whitelist': ['nim'],
    \ 'completor': {opt, ctx -> nim#suggest#sug#GetAllCandidates({start, candidates -> asyncomplete#complete(opt['name'], ctx, start, candidates)})}
    \ })
]]


-- ## C/C++
Plug 'neovim/nvim-lspconfig'

vim.lsp.enable('clangd')
--vim.lsp.enable('nimls')

