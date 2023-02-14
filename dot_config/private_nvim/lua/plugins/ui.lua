return {
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.termguicolors = true
      vim.o.background = 'dark'
      vim.cmd([[colorscheme gruvbox]])
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    dependencies = {
      'nvim-treesitter/playground',
      'andymass/vim-matchup',
    },
    build = ':TSUpdate',
    opts = {
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
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },

  -- NERDTree
  {
    'preservim/nerdtree',
    cmd = { 'NERDTree' },
    dependencies = { 'ryanoasis/vim-devicons', 'Xuyuanp/nerdtree-git-plugin' },
  },

  -- File searching
  {
    'nvim-telescope/telescope.nvim',
    version = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'trouble.nvim',
    },
    cmd = 'Telescope',
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find Files' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Grep Files' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Find Buffers' },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Find Tags' },

      { '<leader>fla', '<cmd>Telescope lsp_code_actions<cr>', desc = 'Code actions' },
      { '<leader>flr', '<cmd>Telescope lsp_references<cr>', desc = 'References' },
    },
    config = function()
      local telescope = require('telescope')
      local trouble = require('trouble.providers.telescope')

      telescope.setup {
        defaults = {
          mappings = {
            i = { ['<c-t>'] = trouble.open_with_trouble },
            n = { ['<c-t>'] = trouble.open_with_trouble },
          },
        },
      }
      telescope.load_extension('fzf')
    end,
  },

  -- Which keymap
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function(_, opts)
      local wk = require('which-key')

      vim.o.timeoutlen = 500
      wk.setup(opts)
      wk.register {
        mode = { 'n', 'v' },
        ['<leader>f'] = { name = '+telescope' },
        ['<leader>fl'] = { name = '+lsp' },
        ['<leader>x'] = { name = '+trouble' },
        ['<leader>h'] = { name = '+gitsigns' },
        ['<leader>ht'] = { name = '+toggle' },
        ['<leader>t'] = { name = '+neotest' },
        ['<leader>d'] = { name = '+debug' },
        ['<leader>z'] = { name = '+zk' },

        -- Lsp global keymaps
        ['<space>e'] = { '<cmd>lua vim.diagnostic.open_float()<CR>', 'Open Float Diagnostics' },
        ['[d'] = { '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'Go To Previous Diagnostic' },
        [']d'] = { '<cmd>lua vim.diagnostic.goto_next()<CR>', 'Go To Next Diagnostic' },
        ['<space>q'] = { '<cmd>lua vim.diagnostic.setloclist()<CR>', 'Set Loclist For Diagnostics' },
      }
    end,
  },

  -- Trouble
  {
    'folke/trouble.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>TroubleToggle<cr>', desc = 'Toggle Trouble' },
      { '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics' },
      { '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Document Diagnostics' },
      { '<leader>xq', '<cmd>TroubleToggle quickfix<cr>', desc = 'Quickfix' },
      { '<leader>xl', '<cmd>TroubleToggle loclist<cr>', desc = 'Loclist' },
    },
    config = true,
  },
}
