--[[ To make nvim vscode-like.

Due to terminal limit of handle <C-S-x>,  (using x to mean an arbitrary character)
  here I map <mapleader> instead of <C-S>
  just because terminal cannot distinguish C-S-x and C-x

Also, trial of mapping <C-`> fails. maybe because it's handled by terminal,
  converting as ASNI control character. See ./lua/vsc-term.lua for implementation details.

And, because I often manully clone git repo (usually in `git@` url),
  here I don't use lazyVim, but vim-plug.

]]
local vim = vim
local Plug = vim.fn['plug#']


vim.call('plug#begin')
local lspCfg = require'lit-lsp'
--Plug 'ryanoasis/vim-devicons'
Plug 'nvim-tree/nvim-web-devicons'  -- opt dep of sidebar and alpha
local tree_nvim = true
if tree_nvim then
  Plug 'nvim-tree/nvim-tree.lua'  -- sidebar
else
  Plug 'preservim/nerdtree'  -- sidebar
end
Plug 'akinsho/toggleterm.nvim'  -- term
Plug 'lewis6991/gitsigns.nvim'  -- git status
Plug 'tpope/vim-fugitive'  -- git command. dep of vim-flog
Plug 'rbong/vim-flog'      -- git graph.
Plug 'nvim-lua/plenary.nvim'  -- dep of telescope, alpha
Plug 'nvim-telescope/telescope.nvim'  -- find files/strings
Plug 'goolord/alpha-nvim'  -- welcome page & opened files history
Plug 'Mofiqul/vscode.nvim' -- vscode theme
Plug 'natecraddock/workspaces.nvim' -- workspace
Plug 'natecraddock/sessions.nvim' -- workspace

vim.call('plug#end')

lspCfg.setup()

-- ## workspace
local sessions = require'sessions'
sessions.setup{}
require'workspaces'.setup{
	hooks = {
		--open = "NvimTreeOpen",
		open_pre = {
		  -- If recording, save current session state and stop recording
		  "SessionsStop",

		  -- delete all buffers (does not save changes)
		  "silent %bdelete!",
		},
		open = function()
		  sessions.load(nil, { silent = true })
		end,

	}
		
}
require'telescope'.load_extension"workspaces"

-- ## theme
if not vim.g.vscode then
require'alpha'.setup(require'alpha.themes.theta'.config)
require'vscode'.setup()
end
vim.wo.number = true

local function run_intty()
	--local res = vim.fn.system({'tty'})
	-- XXX: find is since lua 5.4, but nvim force lua 5.1
	-- return res:match('^/dev/tty/') == 1
	return os.getenv('DISPLAY') == nil
end

local the_colorscheme = "vscode"
local intty = run_intty()
if intty or vim.g.vscode then the_colorscheme = "evening"  -- vscode theme in pure text mode is hard to read
end
vim.cmd.colorscheme(the_colorscheme)


local def_opts = {}
local function map(mode, l, r, opts)  vim.keymap.set(mode, l, r, opts or def_opts) end

vim.g.mapleader = ' '  -- <leader>, defaults to '\\', delete this line on your favor
local shall_pre_leader_map_insert = vim.g.mapleader ~= ' '
local pre_leader_mode = 'n'
if shall_pre_leader_map_insert then pre_leader_mode = {'n', 'i'} end
local function mapl(l, r, opts)  map(pre_leader_mode, '<leader>'..l, r, opts) end

require'highlights'
require'gui_editor_like_keymaps'

mapl('v', lspCfg.toggleMarkdownView)
-- ## buffer mgr
--[[Cannot use: Error executing Lua callback:
 ...share/nvim/plugged/bufferin.nvim/lua/bufferin/buffer.lua:129: attempt to index field 'display' (a nil value) 
]]--
--Plug 'wasabeef/bufferin.nvim'  -- buffer mgr
--mapl('<tab>', '<cmd>Bufferin<cr>', {desc='Toggle Bufferin'})
-- See telescope config below

-- ## sidebar
if not vim.g.vscode then
local tree_cmd = 'NERDTreeToggle'
if tree_nvim then
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  require('nvim-tree').setup()
  tree_cmd = 'NvimTreeFindFileToggle!'
  require'cfg_ntree'
end
mapl('e', '<cmd>' .. tree_cmd .. '<cr>')
end

-- ## term
local toggletermOpt = {
  open_mapping = {[[<leader>t]]},
}
-- Typing spaces is common in terminal, I don't want terminal stuck again and again
if not shall_pre_leader_map_insert then
  toggletermOpt.insert_mappings = false -- if the open mapping applies in insert mode
  toggletermOpt.terminal_mappings = false  -- if the open mapping applies in the TERMINAL mode in the opened terminals
end
map('t', '<M-\\>', '<c-\\><c-n>')  -- escape insert mode in terminal, I often use <esc-.> to ref the last item in the latest cmd
-- Here use Alt-\ to keep consistent with vim
-- map('t', '<M-\\>', '\\', {noremap=true})  -- insert `\` char

require('toggleterm').setup(toggletermOpt)
require('vsc-term')

-- ## git
-- `require('gitsigns').setup()` is done in following file
require('gitsigns-initkeys')

local GitK = 'g'
require('fugitive-flog-keys').setup("<leader>l", "<leader>"..GitK)

if not vim.opt.statusline then  -- empty by default
  vim.opt.statusline=
  --[[Path to the file[+][RO];  "%="-> right pad; %P -> percent ... see `:h 'statusline'` for details
  -- "%{get(b:, 'gitsigns_status', '')}"]]
  "%<%f %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%) %P"
end

mapl(GitK, '<cmd>vert Git<cr>')

-- ## finder
--  not a local, I want it to be a global
tele_bltin = require('telescope.builtin')  -- though u can do :Telescope XX ARG=VAL
--"<cmd>lua tele_bltin.grep_string({search=vim.fn.expand('<cword>')})<cr>"
mapl('fw', function() tele_bltin.grep_string({search=vim.fn.expand('<cword>')}) end, { desc = 'Telescope find word under cursor' })
mapl('ff', tele_bltin.find_files, { desc = 'Telescope find files' })
mapl('fs', tele_bltin.live_grep, { desc = 'Telescope live grep' })
mapl('fg', tele_bltin.git_commits, { desc = 'Telescope live search commits' })
mapl('fm', tele_bltin.marks, { desc = 'Telescope list marks' })
mapl('fh', tele_bltin.help_tags, { desc = 'Telescope help tags' })
local function find_buf()
	tele_bltin.buffers({select_current=true, sort_mru=true})
	vim.api.nvim_buf_set_keymap(0, 'n', 'dd', '<M-d>', {desc="delete selected buffer"})
end
local function ls_buf(opts)
	-- minic typing ESC to escape from insert mode in buffers select page
	find_buf()
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
	'm', true)
end
mapl('fb', find_buf, { desc = 'Telescope buffers' })
mapl('`', '<c-^>', {desc='Switch between current buffer(NOT tab) (alias of CTRL-^, a.k.a. Alt-Tab)'})
mapl(',', ls_buf, {desc='Telescope Buffer Live'})
-- named after :ls
vim.api.nvim_create_user_command("Ls", ls_buf, {})

mapl('?', tele_bltin.keymaps, { desc = 'Telescope help mapkeys' })

