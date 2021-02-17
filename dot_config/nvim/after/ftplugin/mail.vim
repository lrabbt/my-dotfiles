if !exists("no_plugin_maps") && !exists("no_mail_maps")
  nnoremap <buffer> <leader>th :%!pandoc -t html<CR>
endif

let b:heyo = v:true
