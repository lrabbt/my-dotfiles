-- Bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
end

vim.cmd([[packadd packer.nvim]])

-- Auto update when plugins change
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  -- Appearance
  use {
    'ellisonleao/gruvbox.nvim',
    config = function()
      vim.o.termguicolors = true
      vim.o.background = 'dark'
      vim.cmd([[colorscheme gruvbox]])
    end,
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = require('config.lualine'),
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/playground',
      'andymass/vim-matchup',
    },
    run = ':TSUpdate',
    config = require('config.treesitter'),
  }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
    },
    after = { 'nvim-cmp', 'null-ls.nvim' },
    config = require('config.lspconfig'),
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    require = { 'nvim-lua/plenary.nvim' },
    config = require('config.null-ls'),
  }

  -- Completion
  use {
    'L3MON4D3/LuaSnip',
    requires = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_lua').lazy_load()

      vim.api.nvim_create_user_command('LuaSnipEdit', function()
        require('luasnip.loaders').edit_snippet_files {}
      end, {})
    end,
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-omni',
      'saadparwaiz1/cmp_luasnip',
    },
    after = { 'LuaSnip' },
    config = require('config.nvim-cmp'),
  }

  -- Navigation and Handling
  use {
    'tpope/vim-surround',
    'tpope/vim-commentary',
    'tpope/vim-unimpaired',
    'tpope/vim-repeat',
    'tpope/vim-dispatch',
    'tpope/vim-eunuch',
    'lambdalisue/suda.vim',
    'hauleth/vim-backscratch',
  }

  -- NERDTree
  use {
    'preservim/nerdtree',
    requires = { 'ryanoasis/vim-devicons', 'Xuyuanp/nerdtree-git-plugin' },
    cmd = { 'NERDTree' },
  }

  -- Languages
  -- Go
  use { 'fatih/vim-go', run = ':GoUpdateBinaries' }

  -- Rust
  use {
    'rust-lang/rust.vim',
    config = function()
      vim.g.rustfmt_autosave = 1
    end,
  }

  -- Typescript
  use('leafgarland/typescript-vim')

  -- Kotlin
  use('udalov/kotlin-vim')

  -- Nim
  use('alaviss/nim.nvim')

  -- Php
  use('jwalton512/vim-blade')

  -- Kitty
  use('fladson/vim-kitty')

  -- Rasi
  use {
    'Fymyte/rasi.vim',
    ft = 'rasi',
  }

  -- Git integration
  use('tpope/vim-fugitive')
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    after = { 'which-key.nvim' },
    tag = 'release',
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local wk = require('which-key')

          -- Navigation
          wk.register({
            [']c'] = {
              function()
                if vim.wo.diff then
                  return ']c'
                end
                vim.schedule(function()
                  gs.next_hunk()
                end)
                return '<Ignore>'
              end,
              'Next hunk',
            },

            ['[c'] = {
              function()
                if vim.wo.diff then
                  return '[c'
                end
                vim.schedule(function()
                  gs.prev_hunk()
                end)
                return '<Ignore>'
              end,
              'Previous hunk',
            },
          }, { buffer = bufnr, expr = true })

          -- Actions
          wk.register({
            name = '+gitsigns',
            s = { ':Gitsigns stage_hunk<CR>', 'Stage hunk' },
            r = { ':Gitsigns reset_hunk<CR>', 'Reset hunk' },
            S = { gs.stage_buffer, 'Stage buffer' },
            u = { gs.undo_stage_hunk, 'Undo staged hunk' },
            R = { gs.reset_buffer, 'Reset buffer' },
            p = { gs.preview_hunk, 'Preview hunk' },
            b = {
              function()
                gs.blame_line { full = true }
              end,
              'Blame current line',
            },
            d = { gs.diffthis, 'Diff file' },
            D = {
              function()
                gs.diffthis('~')
              end,
              'Diff file',
            },
            tb = { gs.toggle_current_line_blame, 'Toggle current line blame' },
            td = { gs.toggle_deleted, 'Toggle deleted' },
          }, { buffer = bufnr, prefix = '<leader>h' })

          wk.register({
            name = '+gitsigns',
            s = { ':Gitsigns stage_hunk<CR>', 'Stage hunk' },
            r = { ':Gitsigns reset_hunk<CR>', 'Reset hunk' },
          }, { buffer = bufnr, prefix = '<leader>h', mode = 'v' })

          -- Text object
          wk.register({
            ih = { ':<C-U>Gitsigns select_hunk<CR>', 'inner hunk' },
          }, { buffer = bufnr, mode = 'o' })

          wk.register({
            ih = { ':<C-U>Gitsigns select_hunk<CR>', 'inner hunk' },
          }, { buffer = bufnr, mode = 'x' })
        end,
      }
    end,
  }

  -- File searching
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
    after = { 'which-key.nvim', 'trouble.nvim' },
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

      -- Keymaps
      local wk = require('which-key')

      wk.register({
        name = '+telescope',
        f = { '<cmd>Telescope find_files<cr>', 'Find Files' },
        g = { '<cmd>Telescope live_grep<cr>', 'Grep Files' },
        b = { '<cmd>Telescope buffers<cr>', 'Find Buffers' },
        h = { '<cmd>Telescope help_tags<cr>', 'Find Tags' },

        l = {
          name = '+lsp',
          a = { '<cmd>Telescope lsp_code_actions<cr>', 'Code actions' },
          r = { '<cmd>Telescope lsp_references<cr>', 'References' },
        },
      }, { prefix = '<leader>f' })
    end,
  }
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    after = { 'which-key.nvim' },
    config = function()
      local trouble = require('trouble')
      trouble.setup()

      -- Keymaps
      local wk = require('which-key')
      wk.register({
        name = '+trouble',
        x = { '<cmd>TroubleToggle<cr>', 'Toggle Trouble' },
        w = { '<cmd>TroubleToggle workspace_diagnostics<cr>', 'Workspace Diagnostics' },
        d = { '<cmd>TroubleToggle document_diagnostics<cr>', 'Document Diagnostics' },
        q = { '<cmd>TroubleToggle quickfix<cr>', 'Quickfix' },
        l = { '<cmd>TroubleToggle loclist<cr>', 'Loclist' },
      }, { prefix = '<leader>x' })
    end,
  }

  -- Which keymap
  use {
    'folke/which-key.nvim',
    config = require('config.mappings'),
  }

  -- Vimwiki
  use {
    'vimwiki/vimwiki',
    config = function()
      local documents_path = '~/Documents'
      if vim.env.XDG_DOCUMENTS_DIR then
        documents_path = vim.env.XDG_DOCUMENTS_DIR
      end

      vim.g.vimwiki_list = {
        { path = documents_path .. '/vimwiki' },
      }
    end,
  }

  -- Debug
  use {
    'mfussenegger/nvim-dap',
    requires = {
      'jbyuki/one-small-step-for-vimkind',
    },
    after = 'which-key.nvim',
    config = require('config.nvim-dap'),
  }
  use {
    'rcarriga/nvim-dap-ui',
    after = { 'nvim-dap', 'which-key.nvim' },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close {}
      end

      -- Keymaps
      local wk = require('which-key')

      wk.register({
        name = '+debug',
        t = { '<cmd>lua require"dapui".toggle()<CR>', 'Toggle DAP UI' },
        e = { '<cmd>lua require"dapui".eval()<CR>', 'Eval Current Word' },
      }, { prefix = '<leader>d' })

      wk.register({
        name = '+debug',
        e = { '<cmd>lua require"dapui".eval()<CR>', 'Eval Selected Text' },
      }, { prefix = '<leader>d', mode = 'v' })
    end,
  }
  use {
    'theHamsta/nvim-dap-virtual-text',
    after = 'nvim-dap',
    config = function()
      require('nvim-dap-virtual-text').setup {}
    end,
  }
  -- use {
  --   'rcarriga/vim-ultest',
  --   requires = { 'vim-test/vim-test' },
  --   run = ':UpdateRemotePlugins',
  --   after = 'which-key.nvim',
  --   config = require('config.ultest'),
  -- }
  use {
    'nvim-neotest/neotest',
    requires = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-python',
      'nvim-neotest/neotest-go',
    },
    after = { 'which-key.nvim', 'nvim-treesitter' },
    config = require('config.nvim-neotest'),
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
