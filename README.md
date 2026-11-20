# lit nvim rc

## Setup
- install vim-plug, ref [junegunn/vim-plug](https://github.com/junegunn/vim-plug#neovim)
- clone this repo to `$XDG_CONFIG_HOME/nvim` (often ~/.config/nvim)
- run `nvim -c 'PlugUpdate' -c 'qa'`

Requires Neovim 0.11.3 or newer. After adding plugins, run `:PlugInstall` and
restart Neovim. Mason installs Pyright, Ruff, gopls, lua-language-server,
bash-language-server and rust-analyzer on interactive startup; use `:Mason`
to inspect installation status. Node/npm and Go are needed by some installers.
A system-installed clangd is enabled for C/C++ when available.

## Language support

- Python uses a project's `.venv/bin/python` when present; otherwise Pyright
  uses its normal interpreter discovery. Rust runs `cargo check` on save.
- LSP buffers: `gd` definition, `gD` declaration, `gr` references,
  `gi` implementation, `K` documentation, insert-mode `Ctrl-k` signature help,
  `<leader>rn` rename, `<leader>ca` code action, `<leader>cf` format.
- `gl` shows diagnostics, `<leader>dl` opens their location list, and
  `<leader>fd` searches diagnostics. Neovim's `[d` / `]d` navigate diagnostics.
- Existing Git/search/window mappings are preserved.

### Completion

`nvim-cmp` combines LSP, file paths and words from the current buffer. Use
`Ctrl-Space` to request completion, `Ctrl-n` / `Ctrl-p` to select, `Enter` or
`Tab` to accept (including the first suggestion), and `Ctrl-e` to dismiss.
`Ctrl-b` / `Ctrl-f` scroll documentation; `Shift-Tab` selects the previous item.
Nim retains its existing asyncomplete/nimsuggest integration, with cmp disabled
for Nim to avoid two completion engines competing for the popup menu.

LuaSnip and friendly-snippets add language-specific templates to the completion
menu. When the menu is closed, `Tab` expands a snippet or advances its active
placeholder; `Shift-Tab` goes back. Outside a snippet, normal Tab behavior is
preserved. The optional jsregexp build requires `make` and a C compiler.

### Formatting

Conform organizes Python imports with Ruff, then runs Ruff's formatter before
saving (2 second timeout). Ruff is installed by Mason as part of Python support.
Import organization can remove unused imports; project Ruff settings still apply.
Other filetypes fall back to an attached LSP's formatter when supported.
`<leader>cf` formats manually, including files without an attached LSP;
`:ConformInfo` shows formatter availability. Special/nonmodifiable buffers are
not formatted on save. Formatters run locally, not on a remote service.

### Key hints

Which-key shows a classic hint popup after a 300 ms prefix delay in normal,
visual/select and operator-pending modes. Leader groups use Chinese labels.
It does not intercept Space in insert/terminal mode. Existing bindings stay
unchanged: `<leader>e` toggles the tree, `<leader>fs` searches text,
`<leader>fg` searches commits, and Git buffers use `<leader>w` for word diff.
`<leader>?` still searches all mappings with Telescope.

## Configuration checks

From the repository, run `nvim --headless -i NONE -c 'luafile tests/run.lua'`
after installing the plugins and language servers. This checks startup and
the configuration's regression tests without saving any edited buffers.

## Design
I'm used to `VSCode`, so many configures are just aimed to minic it.

## Notes
I use `<Space>` as `<leader>` (set on [init.lua](./init.lua))

Mostly, replace Ctrl-Shift-X with `<leader>X` then you can feel like being in VSCode.

In addition:

- `<leader>?` -> help
- `<leader>l` -> git log
- ``<leader>` `` -> switch current two buffers  (named after Ctrl-Tab in VSCode)
- `<leader>,` -> switch between buffers
- `<leader>t` -> toggle Terminal (as Ctrl-\` cannot be `keymap`-ed)

In Terminal:
- `<A-\>` -> escape terminal insert mode

### Finder
- `<leader>f`:
  - f -> files
  - w -> word
  - s -> string (regex)
  - g -> git commits
  - m -> marks
