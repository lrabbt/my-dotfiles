local lsputil = {}

function lsputil.format_range_operator(line)
  local old_func = vim.go.operatorfunc

  _G.op_func_formatting = function(type)
    local start = vim.api.nvim_buf_get_mark(0, '[')
    local finish = vim.api.nvim_buf_get_mark(0, ']')

    if type == 'line' then
      start[2] = 0
      finish[1] = finish[1] + 1
      finish[2] = 0
    end

    vim.lsp.buf.format {
      async = true,
      range = {
        ['start'] = start,
        ['end'] = finish,
      },
    }
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = 'v:lua.op_func_formatting'

  local keys = 'g@'
  if line then
    keys = keys .. '_'
  end

  vim.api.nvim_feedkeys(keys, 'n', false)
end

function lsputil.lsp_on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, bufopts)
  elseif client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, bufopts)
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set('v', 'gm', function()
      vim.lsp.buf.format { async = true }
    end, bufopts)

    local expropts = { expr = true, silent = true, noremap = true, buffer = bufnr }
    vim.keymap.set('n', 'gm', lsputil.format_range_operator, expropts)
    vim.keymap.set('n', 'gmm', function()
      lsputil.format_range_operator(true)
    end, expropts)
  end

  -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlight then
    vim.cmd([[
      hi! LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi! LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi! LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    ]])
    vim.api.nvim_create_augroup('lsp_document_highlight', {
      clear = false,
    })
    vim.api.nvim_clear_autocmds {
      buffer = bufnr,
      group = 'lsp_document_highlight',
    }
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Diagnostics options
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true,
  })
end

return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = { 'jose-elias-alvarez/null-ls.nvim' },
    config = function()
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

      -- bashls
      nvim_lsp.bashls.setup {
        on_attach = lsputil.lsp_on_attach,
        capabilities = capabilities,
        filetypes = { 'sh', 'bash', 'zsh' },
      }

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

      nvim_lsp.lua_ls.setup {
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
    end,
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    event = 'BufReadPre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = function()
      local null_ls = require('null-ls')
      return {
        sources = {
          -- Formatting
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.prettier.with {
            extra_filetypes = { 'blade', 'php', 'css' },
          },
          null_ls.builtins.formatting.google_java_format,
          null_ls.builtins.formatting.sqlfluff.with {
            extra_args = { '--dialect', 'ansi' },
          },

          -- Diagnostics
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.diagnostics.zsh,
        },
        on_attach = lsputil.lsp_on_attach,
      }
    end,
  },
}
