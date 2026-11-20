local M = {}

function M.setup()
  local wk = require('which-key')
  wk.setup({
    preset = 'classic',
    delay = 300,
    icons = { mappings = false },
    -- Do not intercept Space while typing or using a terminal.
    triggers = { { '<auto>', mode = 'nxso' } },
  })
  wk.add({
    { '<leader>f', group = 'Find / Telescope' },
    { '<leader>d', group = 'Diagnostics' },
    { '<leader>c', group = 'Code actions' },
    { '<leader>r', group = 'Rename / Refactor' },
    { '<leader>h', group = 'Git hunks' },
    { '<leader>e', desc = 'Toggle file tree' },
    { '<leader>t', desc = 'Toggle terminal' },
    { '<leader>g', desc = 'Git status' },
    { '<leader>l', desc = 'Git commit graph' },
    { '<leader>v', desc = 'Toggle Markdown split preview' },
    { '<leader>w', desc = 'Toggle word diff' },
    { '<leader>b', desc = 'Blame current line' },
    { '<leader>B', desc = 'Toggle inline blame' },
    { '<leader>?', desc = 'Find key mappings' },
  })
end

return M
