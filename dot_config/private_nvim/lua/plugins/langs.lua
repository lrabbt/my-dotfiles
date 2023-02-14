return {
  -- Go
  {
    'fatih/vim-go',
    ft = 'go',
    build = ':GoUpdateBinaries',
  },

  -- Rust
  {
    'rust-lang/rust.vim',
    ft = 'rust',
    config = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  -- Typescript
  'leafgarland/typescript-vim',

  -- Kotlin
  'udalov/kotlin-vim',

  -- Nim
  'alaviss/nim.nvim',

  -- Php
  'jwalton512/vim-blade',

  -- Kitty
  'fladson/vim-kitty',

  -- Rasi
  { 'Fymyte/rasi.vim', ft = 'rasi' },
}
