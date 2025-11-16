
-- ## python
-- vim.g.loaded_python3_provider=1

local _G = {}
function _G.setup() end
function _G.toggleMarkdownView() end

local Plug = vim.fn['plug#']

local function doIfExe(exe, func, ...)
  if vim.fn.executable(exe) == 1 then -- ` == 1` is a must as in lua 0 means `true`
    func(...)
  end
end

-- ## Markdown
local use_markview = true
if use_markview then
Plug 'OXY2DEV/markview.nvim'

_G.setup = function ()
  local spec = require("markview.spec")
  spec.config.preview.hybrid_modes = {'n'}
  --local presets = require("markview.presets").tables
  require("markview.extras.editor").setup()
end
_G.toggleMarkdownView = function ()
  vim.cmd "Markview splitToggle"
end

else

Plug 'MeanderingProgrammer/render-markdown.nvim'
_G.setup = function ()
  require('render-markdown').setup{}
  vim.treesitter.start()
end

end -- use_markview


doIfExe('magick', function()
  Plug '3rd/image.nvim'
  local old_setup = _G.setup
  _G.setup = function()
    old_setup()
    require'image'.setup{
      backend = 'sixel',
      integrations = {
	markdown = {
	  only_render_image_at_cursor = true,
        }
      }
    }
  end
end)

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

