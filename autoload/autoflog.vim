function! autoflog#on_same_commit() abort
  let l:current_commit = systemlist("git rev-parse HEAD")[0]
  let l:result = l:current_commit ==# get(b:, "autoflog_current_commit", "")
  if g:autoflog_debug
    if exists("b:autoflog_current_commit")
      echom "Was on " . b:autoflog_current_commit
    endif
    echom "Now on " . l:current_commit
  endif
  let b:autoflog_current_commit = l:current_commit
  return l:result
endfunction

function! autoflog#update() abort
  if &filetype == 'floggraph'
    let b:flog_status_summary = flog#get_status_summary()
    if !autoflog#on_same_commit()
      call flog#populate_graph_buffer()
    endif
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
    if g:autoflog_debug
      echom "Buffer " . a:bufnr . " was marked dirty."
    endif
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
  if exists('*flogmenu#open_git_log')
    call flogmenu#open_git_log(l:opencmd)
  else
    execute ':Flog -all ' . l:opencmd
  endif
  call autoflog#on_same_commit() " to populate b:autoflog_current_commit
  let work_dir = flog#get_initial_workdir()
  let git_dir = flog#get_fugitive_git_dir()
  let b:autoflog_job = jobstart([g:autoflog_exec, l:work_dir, l:git_dir, bufnr()], {})
  autocmd BufLeave <buffer> call autoflog#schedule_stop_listening()
  if g:autoflog_debug
    echom "Started autoflog in buffer " . bufnr() . " with job " . b:autoflog_job
  endif
endfunction

" BufDelete should work but doesn't, so instead we use BufLeave
" and check in a function scheduled momentarily after,
" whether the buffer still exists
function! autoflog#schedule_stop_listening() abort
  let jobstop_cmd = "call autoflog#stop_listening(" . bufnr() . ", " . b:autoflog_job . ")"
  call timer_start(100, {-> execute(l:jobstop_cmd, "")})
endfunction

function! autoflog#stop_listening(bufnr, jobnr) abort
  if !bufexists(a:bufnr)
    if g:autoflog_debug
      echom "Stopping autoflog for buffer " . a:bufnr
    endif
    let buf_index = index(g:autoflog_dirty_buffers, a:bufnr)
    if buf_index >= 0
      call remove(g:autoflog_dirty_buffers, buf_index)
    endif
    call jobstop(a:jobnr)
  endif
endfunction
