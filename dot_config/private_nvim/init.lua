-- Set python2 and python3 inside pyenv virtualenvs
vim.g.python_host_prog = '~/.local/share/pyenv/versions/nvim-python2/bin/python'
vim.g.python3_host_prog = '~/.local/share/pyenv/versions/nvim/bin/python'

-- Set tabulation
vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smarttab = true

-- Show tabulations
vim.o.list = true

-- Set path to find files recursively
vim.opt.path:append('**')

-- Save undo file
vim.o.undofile = true

-- Completion menu
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
