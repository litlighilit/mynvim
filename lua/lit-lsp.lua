
-- ## python
-- vim.g.loaded_python3_provider=1

local _G = {}
function _G.setup() end

local Plug = vim.fn['plug#']

local function doIfExe(exe, func, ...)
  if vim.fn.executable(exe) == 1 then -- ` == 1` is a must as in lua 0 means `true`
    func(...)
  end
end


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
doIfExe('nimlsp', vim.lsp.enable, 'nimls')

return _G

