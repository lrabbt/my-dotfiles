return function()
  local lsputil = require('config.lsputil')
  local nvim_lsp = require('lspconfig')
  local cmp_nvim_lsp = require('cmp_nvim_lsp')

  -- Use a loop to conveniently both setup defined servers
  -- and map buffer local keybindings when the language server attaches
  local servers = {
    'gopls',
    'angularls',
    'nimls',
    'rust_analyzer',
    'ccls',
    'bashls',
    'eslint',
    'jsonls',
  }
  local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = lsputil.lsp_on_attach,
      capabilities = capabilities,
    }
  end

  -- texlab
  nvim_lsp.texlab.setup {
    settings = {
      texlab = {
        build = {
          executable = 'tectonic',
          args = {
            '-X',
            'compile',
            '%f',
            '--synctex',
            '--keep-logs',
            '--keep-intermediates',
          },
        },
      },
    },
    on_attach = lsputil.lsp_on_attach,
    capabilities = capabilities,
  }

  local function on_attach_no_format(client, ...)
    lsputil.lsp_on_attach(client, ...)

    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end

  -- lua-language-server
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  nvim_lsp.sumneko_lua.setup {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
    on_attach = on_attach_no_format,
    capabilities = capabilities,
  }

  -- Vue volar
  nvim_lsp.volar.setup {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
    on_attach = on_attach_no_format,
    capabilities = capabilities,
  }

  -- tsserver
  nvim_lsp.tsserver.setup {
    on_attach = on_attach_no_format,
    capabilities = capabilities,
  }

  -- intelephense
  nvim_lsp.intelephense.setup {
    on_attach = on_attach_no_format,
    capabilities = capabilities,
  }

  -- PyRight
  local pyright_publish_diagnostics = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { update_in_insert = false }
  )
  nvim_lsp.pyright.setup {
    on_attach = lsputil.lsp_on_attach,
    capabilities = capabilities,
    handlers = {
      ['textDocument/publishDiagnostics'] = pyright_publish_diagnostics,
    },
  }

  -- java: jdtls
  nvim_lsp.jdtls.setup {
    on_attach = on_attach_no_format,
    capabilities = capabilities,
  }
end
