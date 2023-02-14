return {
  {
    'mfussenegger/nvim-dap',
    dependencies = { 'jbyuki/one-small-step-for-vimkind', { 'theHamsta/nvim-dap-virtual-text', config = true } },
    keys = {
      { '<leader>dd', '<cmd>lua require"dap".continue()<CR>', desc = 'Start/Stop Debugger' },
      { '<leader>ds', '<cmd>lua require"dap".terminate()<CR>', desc = 'Terminate Debugger' },
      { '<leader>dc', '<cmd>lua require"dap".run_to_cursor()<CR>', desc = 'Run To Cursor' },
      { '<leader>do', '<cmd>lua require"dap".step_over()<CR>', desc = 'Step Over' },
      { '<leader>di', '<cmd>lua require"dap".step_into()<CR>', desc = 'Step Into' },
      { '<leader>dI', '<cmd>lua require"dap".step_out()<CR>', desc = 'Step Out' },
      { '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', desc = 'Toggle Breakpoint' },
      {
        '<leader>dB',
        '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
        desc = 'Set Conditional Breakpoint',
      },
      {
        '<leader>dp',
        '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
        desc = 'Set Log Point Breakpoint',
      },
      { '<leader>dq', '<cmd>lua require"dap".clear_breakpoints()<CR>', desc = 'Clear Breakpoints' },
      { '<leader>dr', '<cmd>lua require"dap".repl.open()<CR>', desc = 'Open REPL' },
      { '<leader>dl', '<cmd>lua require"dap".run_last()<CR>', desc = 'Rerun With Last Configuration' },
    },
    config = function()
      local dap = require('dap')

      -- Lua
      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = 'Attach to running Neovim instance',
          host = function()
            local value = vim.fn.input('Host [127.0.0.1]: ')
            if value ~= '' then
              return value
            end
            return '127.0.0.1'
          end,
          port = function()
            local val = tonumber(vim.fn.input('Port: '))
            assert(val, 'Please provide a port number')
            return val
          end,
        },
      }

      dap.adapters.nlua = function(callback, config)
        callback {
          type = 'server',
          host = config.host or '127.0.0.1',
          port = config.port or 8088,
        }
      end

      -- Php
      dap.adapters.php = {
        type = 'executable',
        command = 'node',
        args = { os.getenv('HOME') .. '/.local/share/vscode-php-debug/out/phpDebug.js' },
      }

      dap.configurations.php = {
        {
          type = 'php',
          request = 'launch',
          name = 'Listen for Xdebug',
          port = 9003,
          pathMappings = {
            ['/app'] = '${workspaceFolder}',
          },
        },
      }

      -- Python
      dap.adapters.python = {
        type = 'executable',
        command = os.getenv('HOME') .. '/.local/share/pyenv/versions/debugpy/bin/python',
        args = { '-m', 'debugpy.adapter' },
      }

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',

          program = function()
            return '${file}'
          end,
          pythonPath = function()
            if vim.fn.executable('pyenv') == 1 then
              local prefix = vim.fn.system('pyenv prefix')
              if vim.v.shell_error == 0 then
                return string.gsub(prefix, '%s', '') .. '/bin/python'
              end
            end

            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python'
            end
          end,
        },
      }

      -- Go
      dap.adapters.go = {
        type = 'executable',
        command = 'node',
        args = { os.getenv('HOME') .. '/.local/share/vscode-go/dist/debugAdapter.js' },
      }

      dap.configurations.go = {
        {
          type = 'go',
          name = 'Debug',
          request = 'launch',
          showLog = false,
          program = '${file}',
          dlvToolPath = vim.fn.exepath('dlv'), -- Adjust to where delve is installed
          debugAdapter = 'dlv-dap',
        },
      }
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'nvim-dap' },
    keys = {
      {
        '<leader>dt',
        function()
          require('dapui').toggle()
        end,
        desc = 'Toggle DAP UI',
      },
      {
        '<leader>de',
        function()
          require('dapui').eval(nil, {})
        end,
        mode = { 'n', 'v' },
        desc = 'Eval Current Text',
      },
    },
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
    end,
  },
}
