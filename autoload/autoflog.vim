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

function! autoflog#window_is_empty() abort
  if bufname("%") == ""
    if line('$') > 1
      return 0
    endif
    return len(getline('.')) == 0
  else
    return 0
  endif
endfunction

function! autoflog#open_flog() abort
  let l:opencmd=''
  if autoflog#window_is_empty()
    " for an empty window, replace it; this is so you can use familiar
    " keybindings to open & orient a split first and then have flog in that
    let l:opencmd='-open-cmd=edit'
  endif
  call flogmenu#open_git_log(l:opencmd)
  let work_dir = flog#get_initial_workdir()
  let git_dir = flog#get_fugitive_git_dir()
  let b:autoflog_job = jobstart([g:autoflog_exec, l:work_dir, l:git_dir, bufnr()])
  autocmd BufLeave <buffer> call autoflog#schedule_stop_listening()
  echom "Started autoflog in buffer " . bufnr() . " with job " . b:autoflog_job
endfunction

" BufDelete should work but doesn't, so instead we use BufLeave
" and check in a function scheduled momentarily after,
" whether the buffer still exists
function! autoflog#schedule_stop_listening() abort
  let jobstop_cmd = "call autoflog#stop_listening(" . bufnr() . ", " . b:autoflog_job . ")"
  echom "Scheduled stop for buffer " . bufnr() . " job " . b:autoflog_job . " with cmd: " . l:jobstop_cmd
  call timer_start(100, {-> execute(l:jobstop_cmd, "")})
endfunction

function! autoflog#stop_listening(bufnr, jobnr) abort
  echom "Might stop autoflog for buffer " . a:bufnr
  if !bufexists(a:bufnr)
    echom "Stopping autoflog for buffer " . a:bufnr
    let buf_index = index(g:autoflog_dirty_buffers, a:bufnr)
    if buf_index >= 0
      call remove(g:autoflog_dirty_buffers, buf_index)
    endif
    call jobstop(a:jobnr)
  endif
endfunction

