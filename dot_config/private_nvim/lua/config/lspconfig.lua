return function()
  local lsputil = require('config.lsputil')
  local nvim_lsp = require('lspconfig')
  local nvim_lsp_util = require('lspconfig.util')
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
  }
  local capabilities = cmp_nvim_lsp.default_capabilities()
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

  -- jsonls
  nvim_lsp.jsonls.setup {
    on_attach = lsputil.lsp_on_attach,
    capabilities = capabilities,
    cmd = { 'vscode-json-languageserver', '--stdio' },
  }

  local function on_attach_no_format(client, ...)
    lsputil.lsp_on_attach(client, ...)

    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
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
          checkThirdParty = false,
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
  local function get_typescript_server_path(root_dir)
    local global_ts = '/usr/lib/node_modules/typescript/lib'
    local found_ts = ''

    local function check_dir(path)
      found_ts = nvim_lsp_util.path.join(path, 'node_modules', 'typescript', 'lib')
      if nvim_lsp_util.path.exists(found_ts) then
        return path
      end
    end

    if nvim_lsp_util.search_ancestors(root_dir, check_dir) then
      return found_ts
    else
      return global_ts
    end
  end

  nvim_lsp.volar.setup {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
    on_attach = on_attach_no_format,
    capabilities = capabilities,
    on_new_config = function(new_config, new_root_dir)
      new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
    end,
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
  local pyright_publish_diagnostics =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = false })
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
