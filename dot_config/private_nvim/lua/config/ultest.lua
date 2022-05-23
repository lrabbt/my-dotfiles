return function()
  local ultest = require('ultest')
  local wk = require('which-key')

  vim.g['test#python#pytest#options'] = '--color=yes'

  local function split_str(inputstr, sep)
    if sep == nil then
      sep = '%s'
    end
    local t = {}
    for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
      table.insert(t, str)
    end
    return t
  end

  ultest.setup {
    builders = {
      ['python#pytest'] = function(cmd)
        -- The command can start with python command directly or an env manager
        local non_modules = { 'python', 'pipenv', 'poetry' }
        -- Index of the python module to run the test.
        local module_index = 1
        if vim.tbl_contains(non_modules, cmd[1]) then
          module_index = 3
        end
        local module = cmd[module_index]

        -- Remaining elements are arguments to the module
        local args = vim.list_slice(cmd, module_index + 1)
        return {
          dap = {
            type = 'python',
            request = 'launch',
            module = module,
            args = args,

            pythonPath = function()
              if vim.fn.executable('pyenv') == 1 then
                local prefix = vim.fn.system('pyenv prefix')
                if vim.v.shell_error == 0 then
                  local full_prefix = string.gsub(prefix, '%s', '')
                  local first_path = split_str(full_prefix, ':')[1]

                  return first_path .. '/bin/python'
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
      end,
      ['go#gotest'] = function(cmd)
        local args = {}
        for i = 3, #cmd - 1, 1 do
          local arg = cmd[i]
          if vim.startswith(arg, '-') then
            -- Delve requires test flags be prefix with 'test.'
            arg = '-test.' .. string.sub(arg, 2)
          end
          args[#args + 1] = arg
        end
        return {
          dap = {
            type = 'go',
            request = 'launch',
            mode = 'test',
            program = '${workspaceFolder}',
            dlvToolPath = vim.fn.exepath('dlv'),
            args = args,
            debugAdapter = 'dlv-dap',
          },
          parse_result = function(lines)
            return lines[#lines] == 'FAIL' and 1 or 0
          end,
        }
      end,
    },
  }

  -- Mappings
  wk.register({
    [']t'] = { '<Plug>(ultest-next-fail)', 'Jump to next failed test' },
    ['[t'] = { '<Plug>(ultest-prev-fail)', 'Jump to previous failed test' },
  }, { noremap = false })

  wk.register({
    name = '+ultest',
    t = { '<Plug>(ultest-run-file)', 'Run all tests in a file' },
    r = { '<Plug>(ultest-run-nearest)', 'Run test closest to the cursor' },
    l = { '<Plug>(ultest-run-last)', 'Run test(s) that were last run' },
    s = { '<Plug>(ultest-summary-toggle)', 'Toggle the summary window between open and closed' },
    q = { '<Plug>(ultest-summary-jump)', "Jump to the summary window (opening if it isn't already)" },
    e = { '<Plug>(ultest-output-show)', 'Show error output of the nearest test' },
    E = { '<Plug>(ultest-output-jump)', 'Show error output of the nearest test and jump to it' },
    a = { '<Plug>(ultest-attach)', "Attach to the nearest test's running process" },
    p = { '<Plug>(ultest-stop-file)', 'Stop all running jobs for current file' },
    P = { '<Plug>(ultest-stop-nearest)', 'Stop any running jobs for nearest test' },
    T = { '<Plug>(ultest-debug)', 'Debug the current file with nvim-dap' },
    R = { '<Plug>(ultest-debug-nearest)', 'Debug the nearest test with nvim-dap' },
  }, { prefix = '<leader>t', noremap = false })
end
