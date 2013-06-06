" quickrun: outputter: xctool
" Author : tokorom <tokorom@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

let s:outputter = quickrun#outputter#buffered#new()
let s:outputter.config = {
\ }

function! s:outputter.finish(session)
  let data = self._result
  lclose
  if stridx(data, '** TEST SUCCEEDED:') > 0
    " Success
    let message = matchstr(data, '** TEST SUCCEEDED:.*)')
    if 0 == strlen(message)
      let message = '** ALL GREEN **'
    endif
    highlight XctoolSuccess term=reverse ctermbg=darkgreen guibg=darkgreen
    echohl XctoolSuccess | echo message | echohl None
  else
    " Failed
    try
      let message = matchstr(data, '** TEST FAILED.*)')
      if 0 == strlen(message)
        let message = '** FAILED **'
      endif
      let errorformat = '%f:%l:%c:\ %m'
      let errors = []
      for l in split(self._result, '\n')
        if l =~ '^.*:.*:.*:.*$' && l !~ '^.*TEST_AFTER_BUILD.*$'
          call add(errors, l)
        endif
      endfor
      cexpr errors
      cwindow
      for winnr in range(1, winnr('$'))
        if getwinvar(winnr, '&buftype') ==# 'xctool'
          call setwinvar(winnr, 'quickfix_title', 'quickrun: ' .
          \   join(a:session.commands, ' && '))
          break
        endif
      endfor
      highlight XctoolFailed term=reverse ctermbg=darkred guibg=darkred
      echohl XctoolFailed | echo message | echohl None
    finally
    endtry
  endif
endfunction


function! quickrun#outputter#xctool#new()
  return deepcopy(s:outputter)
endfunction

let &cpo = s:save_cpo
