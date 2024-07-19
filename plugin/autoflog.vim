let g:autoflog_dirty_buffers = []
let g:autoflog_debug = v:false

let s:script_dir=expand("<sfile>:p:h")
let g:autoflog_exec = s:script_dir . "/../bin/autoflog"

augroup autoflog_check
  autocmd BufEnter * call autoflog#check_buffers()
augroup END

command! -range=0 -complete=customlist,flog#cmd#flog#args#Complete -nargs=* AutoFlog call autoflog#open_flog(flog#cmd#flog#args#GetRangeArgs(<range>, <line1>, <line2>) + [<f-args>])
command! -range=0 -complete=customlist,flog#cmd#flog#args#Complete -nargs=* AutoFlogsplit call autoflog#open_flog(flog#cmd#flog#args#GetRangeArgs(<range>, <line1>, <line2>) + ['-open-cmd=split', <f-args>])
