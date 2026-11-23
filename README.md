# lit nvim rc

## Setup
- install vim-plug, ref [junegunn/vim-plug](https://github.com/junegunn/vim-plug#neovim)
- clone this repo to `$XDG_CONFIG_HOME/nvim` (often ~/.config/nvim)
- run `nvim -c 'PlugUpdate' -c 'qa'`

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

`<leader>fw` searches the cursor word or visual selection literally. Visual
search supports UTF-8, backwards/block/line selections and multiline matches.
It uses the builtin Telescope live-grep picker so quotes and leading dashes
in selected text are treated as pattern text; `<leader>fs` retains the separate
live-grep-args picker for entering ripgrep options.

## Regression checks

From the repository, after installing the existing plugins, run:

```sh
nvim --headless -i NONE -c 'luafile tests/run.lua'
```
