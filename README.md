# lit nvim rc

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


