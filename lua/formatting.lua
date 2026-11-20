local M = {}

function M.setup()
  local conform = require('conform')
  conform.setup({
    formatters_by_ft = {
      python = { 'ruff_organize_imports', 'ruff_format' },
    },
    format_on_save = function(bufnr)
      if vim.bo[bufnr].buftype ~= '' or not vim.bo[bufnr].modifiable then return end
      return { timeout_ms = 2000, lsp_format = 'fallback' }
    end,
  })
  vim.keymap.set('n', '<leader>cf', function()
    conform.format({ async = true, lsp_format = 'fallback' })
  end, { desc = 'Format code' })
end

return M
