function! autoflog#update() abort
  if &filetype == 'floggraph'
    call flog#populate_graph_buffer()
  endif
endfunction

function! autoflog#check_buffers() abort
  let buf_index = index(g:autoflog_dirty_buffers, bufnr())
  if buf_index >= 0
    call autoflog#update()
    call remove(g:autoflog_dirty_buffers, buf_index)
  endif
endfunction

function! autoflog#mark_flog_buffer_dirty(bufnr) abort
  let buf_index = index(g:autoflog_dirty_buffers, a:bufnr)
  if buf_index == -1
    call add(g:autoflog_dirty_buffers, a:bufnr)
  endif
  call autoflog#check_buffers()
endfunction
