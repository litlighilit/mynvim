-- from repo's README, except 'XXX' (see below)
require('gitsigns').setup{
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local opts = {
      buffer = bufnr,
      noremap= true,
      nowait= true,
      }
    local function map(mode, l, r)
      vim.keymap.set(mode, l, r, opts)
    end
    local function mapd(mode, l, r, descStr)
      local nopts = {}
      for k,v in pairs(opts) do nopts[k] = v end
      nopts.desc = descStr
      vim.keymap.set(mode, l, r, nopts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    mapd('n', '<leader>hs', gitsigns.stage_hunk, 'stage hunk')
    mapd('n', '<leader>hr', gitsigns.reset_hunk, 'reset hunk')

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    mapd('n', '<leader>hS', gitsigns.stage_buffer, 'stage buffer')
    mapd('n', '<leader>hR', gitsigns.reset_buffer, 'reset buffer')
    mapd('n', '<leader>hp', gitsigns.preview_hunk, 'preview hunk')
    mapd('n', '<leader>hi', gitsigns.preview_hunk_inline, 'preview hunk inline')

    mapd('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end, 'blame current line with full msg')

    mapd('n', '<leader>hd', gitsigns.diffthis, 'diff this file against index')

    mapd('n', '<leader>hD', function()
      gitsigns.diffthis('~')
    end, 'diff this file against latest commit')

    mapd('n', '<leader>hQ', function() gitsigns.setqflist('all') end, 'gitsigns: setqflist all')
    map('n', '<leader>hq', gitsigns.setqflist)

    -- Toggles
    --  XXX: using tb, tw causes '<leader>t' (I use for toggle terminal) very slow
    map('n', '<leader>B', gitsigns.toggle_current_line_blame)
    map('n', '<leader>w', gitsigns.toggle_word_diff)
    mapd('n', '<leader>b', gitsigns.blame_line, 'blame current line')

    -- Text object
    map({'o', 'x'}, 'ih', gitsigns.select_hunk)
  end
}

