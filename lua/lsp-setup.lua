local M = {}

M.servers = { 'pyright', 'ruff', 'gopls', 'lua_ls', 'bashls', 'rust_analyzer' }

function M.setup()
  require('mason').setup()

  vim.lsp.config('pyright', {
    before_init = function(_, config)
      -- Resolve against the project, not Neovim's working directory.
      if config.root_dir then
        local python = vim.fs.joinpath(config.root_dir, '.venv', 'bin', 'python')
        if vim.fn.executable(python) == 1 then
          config.settings.python.pythonPath = python
        end
      end
    end,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = 'basic',
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
        },
      },
    },
  })
  vim.lsp.config('rust_analyzer', {
    settings = {
      ['rust-analyzer'] = {
        diagnostics = { enable = true },
        checkOnSave = true,
        check = { command = 'check' },
      },
    },
  })
  vim.lsp.config('lua_ls', {
    settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
  })

  require('mason-lspconfig').setup({
    ensure_installed = M.servers,
    automatic_enable = M.servers,
  })
  -- Keep support for a system-installed clangd without forcing its installation.
  if vim.fn.executable('clangd') == 1 then
    vim.lsp.enable('clangd')
  end

  local group = vim.api.nvim_create_augroup('UserLsp', { clear = true })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = group,
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client and client.name == 'ruff' then
        -- Pyright provides Python hover documentation.
        client.server_capabilities.hoverProvider = false
      end
      local function map(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
      end
      map('gd', vim.lsp.buf.definition, 'Go to definition')
      map('gD', vim.lsp.buf.declaration, 'Go to declaration')
      map('gr', vim.lsp.buf.references, 'Find references')
      map('gi', vim.lsp.buf.implementation, 'Go to implementation')
      map('K', vim.lsp.buf.hover, 'Hover documentation')
      map('<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
      map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
      vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help,
        { buffer = ev.buf, desc = 'Signature help' })
    end,
  })

  vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
  vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Diagnostics to location list' })
  vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', { desc = 'Find diagnostics' })
end

return M
