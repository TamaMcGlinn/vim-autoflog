let g:autoflog_dirty_buffers = []

augroup autoflog_check
  autocmd BufEnter * call autoflog#check_buffers()
augroup END

