" Small group of languages to start. Should expand to capture more at some point
let s:print_statements = {
  \'js': "console.log($$);",
  \'ts': 'console.log($$);',
  \'tsx': 'console.log($$);',
  \'coffee': 'console.log $$',
  \'java': 'System.out.println($$);',
  \'py': 'print($$)',
  \'sh': 'echo $$',
  \'c': 'printf($$\n);',
  \'cpp': 'std::cout << $$\n;',
  \'lua': 'print($$)',
  \'pl': 'print $$;',
  \'rb': 'println!($$);',
  \'swift': 'println($$)',
\} 

function! s:get_template_string()
  let ext = expand('%:e')
  let template = s:print_statements[ext]
  if exists('g:vim_logger_templates')
    if has_key(g:vim_logger_templates, ext)
      let template = g:vim_logger_templates[ext]
    endif
  endif

  return template
endfunction

function! s:wrap(text)
  let template = s:get_template_string()
  let result = substitute(template, '\$\$', a:text, 'g')
  return result
endfunction

function! s:paste_into_print_statement()
  " take whatever is in the yank register
  let reg = '0'
  let text = getreg(reg)

  " Add relevant print statements based on filetype
  let @0 = s:wrap(text)

  "Start on a new line and paste in from the yank registry
  normal! o
  normal! "0p==

  " Reset yank register to previous text
  let @0 = text
endfunction

function! s:insert_into_log()
  let ext = expand('%:e')
  let reg = '0'
  let text = getreg(reg)

  " Start a newline
  normal! o

  let template = s:print_statements[ext]
  let @0 = template
  normal! "0p==0f$

  " Find the location of $$ in the line
  let line_pos = line('.')
  let col_pos = col('.')

  " remove the $$
  normal! xx

  startinsert!
  call cursor(line_pos, col_pos)

  let @0 = text
endfunction

function! s:opfunc(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@
  let type = a:type

  if a:0
    " Invoked from visual mode, use gv to get last highlighted text object
    silent exe "normal! gvy"
  elseif a:type == 'line'
    " Invoked linewise, so use V to yank lines
    silent exe "normal! `[V`]y"
  else
    " Invoked characterwise, so just use v to highlight and yank
    silent exe "normal! `[v`]y"
  endif

  " We have our text object in the yank register, so we can just paste it
  call s:paste_into_print_statement()

  " Reset unnamed register
  let &selection = sel_save
  let @@ = reg_save
endfunction

nnoremap <silent> <Plug>LogFromLastYank :<C-U>call <SID>paste_into_print_statement()<CR>
nnoremap <silent> <Plug>LogFromInsertMode :<C-U>call <SID>insert_into_log()<CR>
nnoremap <silent> <Plug>LogFromTextObject :<C-U>set opfunc=<SID>opfunc<CR>g@
vnoremap <silent> <Plug>LogFromTextObject :<C-U>call <SID>opfunc(visualmode(), 1)<CR>

if !hasmapto('<Plug>LogFromLastYank', 'n') || maparg('clp', 'n') ==# ''
  nmap cly <Plug>LogFromLastYank
endif

if !hasmapto('<Plug>LogFromInsertMode', 'n') || maparg('cll', 'n') ==# ''
  nmap cll <Plug>LogFromInsertMode
endif

if !hasmapto('<Plug>LogFromTextObject', 'n') || maparg('cl', 'n') ==# ''
  nmap cl <Plug>LogFromTextObject
endif
if !hasmapto('<Plug>LogFromTextObject', 'v') || maparg('cl', 'v') ==# ''
  vmap cl <Plug>LogFromTextObject
endif

