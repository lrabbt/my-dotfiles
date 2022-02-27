return function()
  local ultest = require('ultest')

  vim.g['test#python#pytest#options'] = '--color=yes'

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
  local opts = { silent = true }
  vim.api.nvim_set_keymap('n', ']t', '<Plug>(ultest-next-fail)', opts)
  vim.api.nvim_set_keymap('n', '[t', '<Plug>(ultest-prev-fail)', opts)
end
