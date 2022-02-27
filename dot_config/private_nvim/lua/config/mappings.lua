return function()
  local wk = require('which-key')

  vim.o.timeoutlen = 500

  wk.setup()
end
