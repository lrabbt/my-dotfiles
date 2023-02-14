return {
  {
    'mickael-menu/zk-nvim',
    dependencies = { 'telescope.nvim' },
    keys = {
      {
        '<leader>zn',
        "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
        desc = 'Create a new note after asking for its title',
      },
      { '<leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", desc = 'Open notes' },
      { '<leader>zt', '<Cmd>ZkTags<CR>', desc = 'Open notes associated with the selected tags' },
      {
        '<leader>zf',
        "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
        desc = 'Search for the notes matching a given query',
      },
      {
        'v',
        '<leader>zf',
        ":'<,'>ZkMatch<CR>",
        mode = 'v',
        desc = 'Search for the notes matching the current visual selection',
      },
    },
    cmd = {
      'ZkMatch',
      'ZkNotes',
      'ZkTags',
      'ZkCd',
      'ZkNew',
      'ZkIndex',
      'ZkLinks',
      'ZkBacklinks',
      'ZkInsertLink',
      'ZkInsertLinkAtSelection',
      'ZkNewFromTitleSelection',
      'ZkNewFromContentSelection',
    },
    opts = {
      picker = 'telescope',
    },
    config = function(_, opts)
      require('zk').setup(opts)
    end,
  },
}
