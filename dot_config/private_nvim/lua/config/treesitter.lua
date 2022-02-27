return function()
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true,
      disable = {
        'php',
        'phpdoc',
      },
    },
    incremental_selection = {
      enable = true,
    },
    -- vim-matchup config
    matchup = {
      enable = true,
    },
  }

  vim.g.matchup_matchparen_offscreen = { method = 'popup' }
end
