function! s:paste_into_print_statement()
  " take whatever is in the yank register
  let text = getreg("0")
  echohl text
endfunction


nnoremap <silent> <Plug>PasteInsidePrintStatement :<C-U>call <SID>paste_into_print_statement()<CR>

if !hasmapto('<Plug>PaseInsidePrintStatement', 'n') || maparg('clp', 'n') ==# ''
  nmap clp <Plug>PasteInsidePrintStatement
endif

