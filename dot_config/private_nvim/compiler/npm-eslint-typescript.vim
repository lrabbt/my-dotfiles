if exists("current_compiler")
  finish
endif
let current_compiler = "npm-eslint-typescript"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat=
      \\ \ %l:%c\ \ %t%*[^\ ]\ %m,
      \%-G>%.%#,
      \%-GLinting\ %.%#,
      \All\ files\ pass\ linting\.,
      \Checking\ formatting\.\.\.,
      \All\ matched\ files\ use\ Prettier\ code\ style\!,
      \%C%f,
      \%+P%f,
      \%-Q
CompilerSet makeprg=npm\ run\ lint
