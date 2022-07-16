return function()
  local neotest = require('neotest')
  local wk = require('which-key')

  local neotest_python = require('neotest-python')
  local neotest_go = require('neotest-go')

  neotest.setup {
    adapters = {
      neotest_python,
      neotest_go,
    },
  }

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
  wk.register {
    [']t'] = { jump_next, 'Jump to next failed test' },
    ['[t'] = { jump_prev, 'Jump to previous failed test' },
  }

  wk.register({
    name = '+neotest',
    t = { run_file, 'Run all tests in a file' },
    r = { run_near, 'Run test closest to the cursor' },
    l = { run_last, 'Run test(s) that were last run' },
    s = { summary_toggle, 'Toggle the summary window between open and closed' },
    q = { summary_open, "Jump to the summary window (opening if it isn't already)" },
    e = { output_open, 'Show error output of the nearest test' },
    E = { output_open_enter, 'Show error output of the nearest test and jump to it' },
    a = { run_attach, "Attach to the nearest test's running process" },
    p = { run_stop, 'Stop all running jobs for current file' },
    T = { run_file_dap, 'Debug the current file with nvim-dap' },
    R = { run_near_dap, 'Debug the nearest test with nvim-dap' },
  }, { prefix = '<leader>t' })
end
