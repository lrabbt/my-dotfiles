local lsputil = {}

function lsputil.format_range_operator()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function(type)
    local start = vim.api.nvim_buf_get_mark(0, '[')
    local finish = vim.api.nvim_buf_get_mark(0, ']')

    if type == 'line' then
      start[2] = 0
      finish[1] = finish[1] + 1
      finish[2] = 0
    end

    vim.lsp.buf.range_formatting({}, start, finish)
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = 'v:lua.op_func_formatting'

  return 'g@'
end

function lsputil.lsp_on_attach(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('v', 'gm', ':lua vim.lsp.buf.range_formatting()<CR>', opts)

    local expropts = { expr = true, silent = true, noremap = true }
    buf_set_keymap('n', 'gm', "v:lua.require'config.lsputil'.format_range_operator()", expropts)
    buf_set_keymap('n', 'gmm', "v:lua.require'config.lsputil'.format_range_operator() .. '_'", expropts)
  end

  -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.cmd [[
      hi! LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi! LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi! LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    ]]
    vim.api.nvim_create_augroup('lsp_document_highlight', {
      clear = false
    })
    vim.api.nvim_clear_autocmds({
      buffer = bufnr,
      group = 'lsp_document_highlight',
    })
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
