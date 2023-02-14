return {
  'tpope/vim-fugitive',

  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    tag = 'release',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map_expr(mode, l, r, desc, expr)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc, expr = expr })
        end

        local function map(mode, l, r, desc)
          map_expr(mode, l, r, desc, false)
        end

        -- Navigation
        map_expr('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, 'Next hunk')

        map_expr('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, 'Previous hunk')

        -- Actions
        -- stylua: ignore start
        map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', 'Stage hunk')
        map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', 'Reset hunk')
        map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
        map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo staged hunk')
        map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
        map('n', '<leader>hb', function() gs.blame_line { full = true } end, 'Blame current line')
        map('n', '<leader>hd', gs.diffthis, 'Diff file')
        map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff file')
        map('n', '<leader>htb', gs.toggle_current_line_blame, 'Toggle current line blame')
        map('n', '<leader>htd', gs.toggle_deleted, 'Toggle deleted')

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'inner hunk')
      end,
    },
  },
}
