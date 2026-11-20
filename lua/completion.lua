local M = {}

function M.setup()
  local cmp = require('cmp')
  -- Set capabilities before any language server starts.
  vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })

  cmp.setup({
    enabled = function()
      -- Nim already has its own asyncomplete/nimsuggest integration.
      return vim.bo.filetype ~= 'nim' and vim.bo.buftype ~= 'prompt'
    end,
    snippet = { expand = function(args) vim.snippet.expand(args.body) end },
    completion = { completeopt = 'menu,menuone,noinsert' },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.confirm({ select = true }) else fallback() end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_prev_item() else fallback() end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'buffer' },
    }),
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    experimental = { ghost_text = true },
  })
end

return M
