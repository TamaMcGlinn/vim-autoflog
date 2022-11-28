let g:autoflog_dirty_buffers = []

let s:script_dir=expand("<sfile>:p:h")
let g:autoflog_exec = s:script_dir . "/../bin/autoflog"

augroup autoflog_check
  autocmd BufEnter * call autoflog#check_buffers()
augroup END

