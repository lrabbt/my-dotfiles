return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-python',
      'nvim-neotest/neotest-go',
      'nvim-treesitter',
    },
    keys = {
      { ']t', nil, desc = 'Jump to next failed test' },
      { '[t', nil, desc = 'Jump to previous failed test' },
      { '<leader>tt', nil, desc = 'Run all tests in a file' },
      { '<leader>tr', nil, desc = 'Run test closest to the cursor' },
      { '<leader>tl', nil, desc = 'Run test(s) that were last run' },
      { '<leader>ts', nil, desc = 'Toggle the summary window between open and closed' },
      { '<leader>tq', nil, desc = "Jump to the summary window (opening if it isn't already)" },
      { '<leader>te', nil, desc = 'Show error output of the nearest test' },
      { '<leader>tE', nil, desc = 'Show error output of the nearest test and jump to it' },
      { '<leader>ta', nil, desc = "Attach to the nearest test's running process" },
      { '<leader>tp', nil, desc = 'Stop all running jobs for current file' },
      { '<leader>tT', nil, desc = 'Debug the current file with nvim-dap' },
      { '<leader>tR', nil, desc = 'Debug the nearest test with nvim-dap' },
    },
    config = function()
      local neotest = require('neotest')

      local neotest_python = require('neotest-python')
      local neotest_go = require('neotest-go')

      neotest.setup {
        adapters = {
          neotest_python,
          neotest_go,
        },
      }

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { desc = desc })
      end

      local function jump_next()
        neotest.jump.next { status = 'failed' }
      end

      local function jump_prev()
        neotest.jump.prev { status = 'failed' }
      end

      local function run_file()
        neotest.run.run(vim.fn.expand('%'))
      end

      local function run_near()
        neotest.run.run()
      end

      local function run_last()
        neotest.run.run_last()
      end

      local function summary_toggle()
        neotest.summary.toggle()
      end

      local function summary_open()
        neotest.summary.open()
      end

      local function output_open()
        neotest.output.open()
      end

      local function output_open_enter()
        neotest.output.open { enter = true }
      end

      local function run_attach()
        neotest.run.attach()
      end

      local function run_stop()
        neotest.run.stop()
      end

      local function run_file_dap()
        neotest.run.run { vim.fn.expand('%'), strategy = 'dap' }
      end

      local function run_near_dap()
        neotest.run.run { strategy = 'dap' }
      end

      -- Mappings
      map('n', ']t', jump_next, 'Jump to next failed test')
      map('n', '[t', jump_prev, 'Jump to previous failed test')

      map('n', '<leader>tt', run_file, 'Run all tests in a file')
      map('n', '<leader>tr', run_near, 'Run test closest to the cursor')
      map('n', '<leader>tl', run_last, 'Run test(s) that were last run')
      map('n', '<leader>ts', summary_toggle, 'Toggle the summary window between open and closed')
      map('n', '<leader>tq', summary_open, "Jump to the summary window (opening if it isn't already)")
      map('n', '<leader>te', output_open, 'Show error output of the nearest test')
      map('n', '<leader>tE', output_open_enter, 'Show error output of the nearest test and jump to it')
      map('n', '<leader>ta', run_attach, "Attach to the nearest test's running process")
      map('n', '<leader>tp', run_stop, 'Stop all running jobs for current file')
      map('n', '<leader>tT', run_file_dap, 'Debug the current file with nvim-dap')
      map('n', '<leader>tR', run_near_dap, 'Debug the nearest test with nvim-dap')
    end,
  },
}
