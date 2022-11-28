function! autoflog#update() abort
  call flog#populate_graph_buffer()
endfunction

function! autoflog#check_buffers(bufnr) abort
  let buf_index = index(g:autoflog_dirty_buffers, a:bufnr)
  if buf_index >= 0
    call autoflog#update()
    call remove(g:autoflog_dirty_buffers, buf_index)
  endif
endfunction

function! autoflog#mark_flog_buffer_dirty(bufnr) abort
  call add(g:autoflog_dirty_buffers, a:bufnr)
  call autoflog#check_buffers()
endfunction
