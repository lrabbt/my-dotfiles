return function()
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
        ['/var/www/html'] = '${workspaceFolder}',
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

  -- Mappings
  local wk = require('which-key')
  wk.register({
    name = '+debug',
    d = { '<cmd>lua require"dap".continue()<CR>', 'Start/Stop Debugger' },
    s = { '<cmd>lua require"dap".terminate()<CR>', 'Terminate Debugger' },
    c = { '<cmd>lua require"dap".run_to_cursor()<CR>', 'Run To Cursor' },
    o = { '<cmd>lua require"dap".step_over()<CR>', 'Step Over' },
    i = { '<cmd>lua require"dap".step_into()<CR>', 'Step Into' },
    I = { '<cmd>lua require"dap".step_out()<CR>', 'Step Out' },
    b = { '<cmd>lua require"dap".toggle_breakpoint()<CR>', 'Toggle Breakpoint' },
    B = {
      '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
      'Set Conditional Breakpoint',
    },
    p = {
      '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
      'Set Log Point Breakpoint',
    },
    q = { '<cmd>lua require"dap".clear_breakpoints()<CR>', 'Clear Breakpoints' },
    r = { '<cmd>lua require"dap".repl.open()<CR>', 'Open REPL' },
    l = { '<cmd>lua require"dap".run_last()<CR>', 'Rerun With Last Configuration' },
  }, { prefix = '<leader>d' })
end
