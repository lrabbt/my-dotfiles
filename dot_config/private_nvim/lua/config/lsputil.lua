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

return lsputil
