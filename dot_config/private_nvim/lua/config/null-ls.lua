return function()
  local lsputil = require('config.lsputil')
  local null_ls = require('null-ls')

  null_ls.setup {
    sources = {
      -- Formatting
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.prettier.with {
        extra_filetypes = { 'blade', 'php' },
      },
      null_ls.builtins.formatting.google_java_format,

      -- Diagnostics
      null_ls.builtins.diagnostics.shellcheck,
      null_ls.builtins.diagnostics.zsh,
    },
    on_attach = lsputil.lsp_on_attach,
  }
end
