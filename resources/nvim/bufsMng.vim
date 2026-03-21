" write it in vimscript first
" buffers -> windows -> tabpage
" a buffers appears in more than one windows
" but each window has unique id and winnr


function MatchingPathExt(pat,ext,idx,val)
  let buf_fullpath = a:val['name']
  if !empty(buf_fullpath)

    let pathChunks = split(buf_fullpath,'/')

    let patMatch = buf_fullpath->match(a:pat)
    if patMatch == -1 && a:pat!='*'
      return 0
    endif

    let chk_len = len(pathChunks)
    let filename = pathChunks[chk_len-1]
    let L_fn  = len(filename)
    let dotMatch = filename->match('\.')

    if dotMatch == -1
      return 0
    endif

    if  filename[dotMatch+1:L_fn-1]->match(a:ext) == -1
      return 0
    endif

    return 1
  endif
  return 0
endfunction

function GroupBuffers(pat,ext)
  " a:pattern: contained in fullpath
  " a:ext    : extension of the the file type
  let MatchedCB = function('MatchingPathExt',[a:pat,a:ext])
  " suppose only active buffers consistent with :ls
  let matched = getbufinfo({'buflisted':1})->filter(MatchedCB)
  let matched = map(matched,"v:val['bufnr']")
  call NewTab(a:ext .. '@' .. a:pat, matched)
endfunction

function NewTab(newTabName, bufs)
  tabnew
  if exists(':TabRename')
    call LualineRenameTab(a:newTabName)
  endif

  let tmpBuf = bufnr()
  let L = len(a:bufs)

  if L == 0
    return
  endif

  let R = min([L-2,14])
  if R > 16
    echo ">16 items found, Note maybe not all related buffers shown"
  endif

  let actionList = ['vsplit','split','call win_gotoid(win_getid(3)) | split',
        \ 'call win_gotoid(win_getid(1)) | split','call win_gotoid(win_getid(4)) | split',
        \ 'call win_gotoid(win_getid(1)) | split','call win_gotoid(win_getid(5)) | split',
        \ 'call win_gotoid(win_getid(1)) | vsplit',
        \ 'call win_gotoid(win_getid(3)) | vsplit','call win_gotoid(win_getid(5)) | vsplit',
        \ 'call win_gotoid(win_getid(7)) | vsplit','call win_gotoid(win_getid(1)) | vsplit',
        \ 'call win_gotoid(win_getid(4)) | vsplit','call win_gotoid(win_getid(7)) | vsplit',
        \ 'call win_gotoid(win_getid(10)) | vsplit']
  for i in range(0,R)
    execute(actionList[i])
  endfor

  for i in range(0,L-1)
    " Assign each buffer a window
    call win_gotoid(win_getid(i+1))
    execute('b ' .. a:bufs[i])
  endfor

  execute('bd! ' . tmpBuf)
endfunction

"call GroupBuffers('Inits','sh')

" check help setting-tabline too
" lualine has tabline settings too


function MoveToWin(win_nr)
  call win_gotoid(win_getid(a:win_nr))
endfunction

function MoveToOpenBuf(target_buf)
  " for the current tabpage only, but B as like b --complete=buffers to do similar things

  let rbufnr = bufnr(a:target_buf)

  for tp in range(1,tabpagenr('$'))
    let bfl = tabpagebuflist(tp)
    if index(bfl,rbufnr) != -1
      execute('tabnext ' .. tp)
      let bufwinid = bufwinid(a:target_buf)
      call win_gotoid(bufwinid)
      return
    endif
  endfor
  "let bufwinid = bufwinid(a:target_buf)
  " let bufwinid = win_findbuf(a:target_buf)
  echohl WarningMsg | echo "the buffer not found" | echohl None
endfunction

command! -nargs=* Bufgrp call GroupBuffers(<f-args>)
" Go to win in this tag
command! -nargs=1 GoWin call MoveToWin(<f-args>)
" write the buffer and edit the file, like "Save as...", there is ":saveas", same
command! -nargs=1 -complete=file W write <args> | edit <args>
command! -nargs=1 -complete=buffer B call MoveToOpenBuf(<f-args>)

