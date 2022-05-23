return function()
  local wk = require('which-key')

  vim.o.timeoutlen = 500

  wk.setup()

  -- Lsp global keymaps
  wk.register {
    ['<space>e'] = { '<cmd>lua vim.diagnostic.open_float()<CR>', 'Open Float Diagnostics' },
    ['[d'] = { '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'Go To Previous Diagnostic' },
    [']d'] = { '<cmd>lua vim.diagnostic.goto_next()<CR>', 'Go To Next Diagnostic' },
    ['<space>q'] = { '<cmd>lua vim.diagnostic.setloclist()<CR>', 'Set Loclist For Diagnostics' },
  }
end
