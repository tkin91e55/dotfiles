let g:init_path = getcwd()
command GoInitPath :execute 'lcd' g:init_path

""""""""""""""""""""
"
" Vim: options
"
""""""""""""""""""""

" for no compatible mode, for netrw, `:help netrw-start`
" Use Vim settings, rather than Vi settings (much better!). This must be first, because it changes
" other options as a side effect. Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" favor python linters over POSIX convention that text files ending with trailing newline
set nofixeol

" When the +eval feature is missing, the set command above will be skipped. Use a trick to reset
" compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

filetype plugin on









let g:markdown_folding = 1
let g:markdown_recommended_style=0 " the Tim Pope ftp markdown.vim set shfitwidth=4
if !has('macunix') || has('nvim')
  " let g:markdown_fenced_languages = ['python','html','java','bash=sh','css']
  " problematic in telescope repoDoc grep/file file, disabled java
  let g:markdown_fenced_languages = ['python','html','bash=sh','css']
endif

set mouse=a

set undodir=~/.vim/undodir
set undofile



set path=.
set path+=**
set wildignore+=**/node_modules/**
set wildignore+=**/.git/**
set wildmenu

set incsearch
set hlsearch
"Since I really use /\c{pattern} a lot...as to use \c to search either "Big/small letter
set ignorecase
set smartcase "smartcase requires ignorecase
syntax on
set nu
"relativenumber take priority over `:set nu`,
"wrong, setting relnu without set nu
"caused the current line marked as 0 instead of line number
set relativenumber

set nowrap
"useful when nowrap is set
set sidescrolloff=15

"wm is no good that, if I work on different OS, the margin is changing
"tw is better for standardization
"luckily, wrap margin(wm) has lower priority than text width (tw), check :help wm and :help tw
" set wrapmargin=100 " it counts from the right margin...
" ColorColumn overriden by gruvbox...
highlight ColorColumn ctermbg=magenta ctermfg=blue
" my filetypes to mark colorcolumn
let g:cc_filetypes = '\(py\|html\|css\|js\|md\|lua\|java\|cs\|scss\)'

augroup ColorColumn
  autocmd!
  " buftype means those nowrite, readonly, quickfix attribute
  autocmd FileType * if &buftype == '' && match(expand('%:e'),g:cc_filetypes) != -1
        \ | setlocal colorcolumn=101 | endif
  " autocmd BufLeave * if &buftype == '' && match(expand('%:e'),g:cc_filetypes) != -1
  " \ | setlocal colorcolumn= | endif
augroup END
" set colorcolumn=101
"match ColorColumn "\%101v."
match ColorColumn "\%>101v."
"colorcoumn is a good matched use with text width
set textwidth=100
" To avoid problems with flags that are added in the future,
" use the "+=" and "-=" feature of ":set" |add-option-flags|.
set formatoptions+="lv"

"set autocomplete option
set completeopt=menuone,noselect

"set cursor for python, markdonws those indentation patter buffers
set cursorline
set cursorcolumn

""""""""""""""""""""
"
" Indentation and space-tab
"
""""""""""""""""""""

set autoindent
set expandtab
set tabstop=2
set shiftwidth=2

""""""""""""""""""""
"
" Colorscheme
"
""""""""""""""""""""
" For more info, `:help colorscheme`

" or :colorscheme evening during runtime
" for vim, use `vimdiff`, but for neovim, it is `nvim -d`
if &diff
    syntax off
    colorscheme evening
endif

""""""""""""""""""""
"
" Trail spaces
"
""""""""""""""""""""

" Customize the trailing space, tabs...
" Ref: https://unicode-table.com/en/
" also use `g8` or :ascii to show the encoding of char
"set listchars=tab:»,trail:↛,nbsp:~
"set listchars=tab:»■,trail:↛,leadmultispace:━━━┨
set listchars=tab:»■,trail:↛
set list

 "remove traling spaces
autocmd BufWritePre * :%s/\s\+$//e
"autocmd BufWritePre *.md :%s/\s\+$//e
"autocmd BufWritePre *.py :%s/\s\+$//e

""""""""""""""""""""
"
" Vim:Netrw
"
""""""""""""""""""""

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15

"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

"use command FS to start a fixed width vertical netrw explorer

function! Explore_sitepackages(chcwd)
  if has_key(environ(), 'VIRTUAL_ENV')
    let py_version = execute('!python --version')
    let py_version = matchstr(py_version,"Python \\zs\\(3\...\\)\\ze")
    let sitepackages =  expand('$VIRTUAL_ENV') . '/lib/python' . py_version . '/site-packages'
    "echo sitepackages
    execute('Vexplore ' . sitepackages . ' | set wfw')

    if a:chcwd
      execute('tcd ' . sitepackages)
    endif
  else
    return
  endif
endfunction

command! -nargs=* FS Vex <args> | set wfw
command! -nargs=* FSV execute('tabe') | call Explore_sitepackages(1)
command! -nargs=* FSVW call Explore_sitepackages(0)

"""""""""""""""""""""""
"
" Vim:Remapping keys
"
""""""""""""""""""""""
let mapleader = " "

" pasting repetitive "0 and system clipboard
nnoremap <silent> <leader>p "0p
nnoremap <silent> <leader>P "0P
nnoremap <silent> <leader>= "+p
nnoremap <silent> <leader>+ "+P
vnoremap <silent> <leader>p "0p
vnoremap <silent> <leader>P "0P
vnoremap <silent> <leader>= "+p
vnoremap <silent> <leader>+ "+P


" +/- split windows size
map + <C-W>5>
map - <C-W>5<
map <PageDown> <C-w>5-
map <PageUp> <C-w>5+
map zh 10z<Left>
map zl 10z<Right>

nnoremap <silent> <C-y> 5<C-y>
nnoremap <silent> <C-e> 5<C-e>

" move vertically to next non-blank
" refer to `:help search`, `:help virtcol`, `:help atom`, `:help search-range`
" `:help virtcol`, returning the virtual column number at the cursor
" `:help search`, flag 'b' is backwards, flag 'W' is no wrap of buffer
" `:help search-range/atom/ordinary-atom`: \% is limiting the search
"       \%{num}v is limiting to virtual column
" `:help character-classes` \S is non-whitespace characters
" `.` between atoms is just concatenation
nnoremap <silent> <C-k> :call search('\%' . virtcol('.') . 'v\S', 'bW')<CR>
nnoremap <silent> <C-j> :call search('\%' . virtcol('.') . 'v\S', 'W')<CR>



"vnoremap <C-k> :call search('\%' . virtcol('.') . 'v\S', 'bWs')<CR>
"vnoremap <C-j> :call search('\%' . virtcol('.') . 'v\S', 'Ws')<CR>

"""""""""""""""""""""""
"
" Vim: Tabpages, Windows and Buffers
"
" * tabnext 1 " go to tab 1
" * tabnext # " go to last accessed page
""""""""""""""""""""""

" this allows :T1, :T3 :T# too
command! -nargs=1 T tabnext <args>

" alt + hkjl to move between windows
" no good for macOS Termianl and iTerm2
" solution: https://stackoverflow.com/questions/7501092/can-i-map-alt-key-in-vim
" for vim, <Esc>h is <A-h>, https://stackoverflow.com/questions/6778961/alt-key-shortcuts-not-working-on-gnome-terminal-with-vim/10216459#10216459
"  use has('macunix') to differentiate, on macOS it is 1, on SUSE it is 0
"  use has('linux')  to  differentiate, on macOS it is 0, on SUSE it is 1
"  use has('unix')  to  differentiate, on macOS it is 1,  on SUSE it is 1
"  consistent on (macOS and SUSE) for (vim and neovim)

if has('linux')
  nnoremap <silent> <A-h> <C-w>h
  nnoremap <silent> <A-j> <C-w>j
  nnoremap <silent> <A-k> <C-w>k
  nnoremap <silent> <A-l> <C-w>l
elseif has('macunix')
  nnoremap <silent> ˙ <C-w>h
  nnoremap <silent> ∆ <C-w>j
  nnoremap <silent> ˚ <C-w>k
  nnoremap <silent> ¬ <C-w>l
endif

" Terminal related
nnoremap <silent> <leader>st :split<CR>:terminal<CR>
nnoremap <silent> <leader>vt :vertical terminal<CR>
tnoremap <silent> <C-Esc> <C-\><C-n> " in sake of tmux/opencode ESC escape
if has('linux')
  tnoremap <silent> <A-h> <C-\><C-n><C-w>h
  tnoremap <silent> <A-j> <C-\><C-n><C-w>j
  tnoremap <silent> <A-k> <C-\><C-n><C-w>k
  tnoremap <silent> <A-l> <C-\><C-n><C-w>l
elseif has('macunix')
  tnoremap <silent> ˙ <C-\><C-n><C-w>h
  tnoremap <silent> ∆ <C-\><C-n><C-w>j
  tnoremap <silent> ˚ <C-\><C-n><C-w>k
  tnoremap <silent> ¬ <C-\><C-n><C-w>l
endif

set timeout ttimeoutlen=50 "needed when using Escape key code

" visual mode indentation and shifting up/down
"vnoremap <silent> < <gv "not very useful
"vnoremap <silent> > >gv "not very useful
vnoremap <silent> J :move '>+1<CR>gv-gv
vnoremap <silent> K :move '<-2<CR>gv-gv

" I hope this helps mostly auto vertical new window for :help, :Git
" autocmd WinNew * wincmd H " no good, <C-W>s is still vertical split...
" Ptts: must use '' but not \"\" for regex match
"       if match(expand("<amatch>"),"\(help\|fugitive\|netrw\)") != -1| setlocal wfw | endif
"       does not work
augroup made_vertical
  autocmd!
  autocmd FileType fugitive,help,netrw,git
        \ setlocal bufhidden=unload |
        \ wincmd H |
        \ vertical resize 79 |
        \ if match(expand("<amatch>"),'\(help\|fugitive\|netrw\|git\)') != -1| setlocal wfw | endif
augroup END

"""""""""""""""""""""""
"
" Vim: Insert mode
" insert mode, I insert at first char and A append at last char
"
"""""""""""""""""""""""






"inoremap <silent> <C-h> <ESC>I
"inoremap <silent> <C-l> <ESC>A
" inoremap () ()<ESC>i # just use <C-s> surround.vim
" inoremap [] []<ESC>i
" inoremap {} {}<ESC>i
" inoremap '' ''<ESC>i
" inoremap `` ``<ESC>i
" inoremap <> <><ESC>i


" https://vim.fandom.com/wiki/Redirect_g_search_output
command! -nargs=? Filter let @a='' | execute 'g/<args>/y A' | new | setlocal bt=nofile | put! a

" or :put=execute('PrintFilePath') for writing into buffer
command! PrintFilePath echo expand('%:p')
command! PutFilePath put=expand('%:p')


"move current line to the end of buffer without moving cursor

let mapleader = "c"
nnoremap <leader>m :call MoveToEnd()<CR>

function! MoveToEnd()
  execute "normal! ddGp``"
endfunction

"copy current line to the end of buffer without moving cursor
nnoremap <leader>p YGp``


""""""""""""""""""""
" Vim:Vimgrep over opened buffers
""""""""""""""""""""

" Search in all currently opened buffers
function! ClearQuickfixList()
  call setqflist([])
endfunction
function! Vimgrepall(pattern)
  call ClearQuickfixList()
  exe 'bufdo vimgrepadd ' . a:pattern . ' %'
  cnext
endfunction
command! -nargs=1 GrepInBuffers call Vimgrepall(<f-args>)


""""""""""""""""""""
"
" Vim: atomic moving an editing file
" https://stackoverflow.com/questions/10884520/move-file-within-vim
"
""""""""""""""""""""

function! AtomicRenameCurBuf(new_name)
  let curbuf_filename = expand('%')
  let curbuf = bufnr()
  call rename(curbuf_filename,a:new_name)
  exe 'edit ' . a:new_name
  exe 'bd' . curbuf
  echo "Moved " . curbuf_filename . ' to ' . a:new_name
endfunction
command! -nargs=1 -complete=buffer Move call AtomicRenameCurBuf(<f-args>)

""""""""""""""""""""
"
" Vim:Global Copy only matched patterns
" https://vim.fandom.com/wiki/Copy_search_matches#Copy_matches
" usage: use / to search a pattern, clear a reg (q{reg}q) and :Ex mode CopyMatches {Capital reg}
" compare with :g/{pattern}/y {Capital reg}, this is linewise
""""""""""""""""""""

"Global Copy only matched patterns
" https://vim.fandom.com/wiki/Copy_search_matches#Copy_matches
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)


""""""""""""""""""""
"
" Buffer Specific
"
" https://vim.fandom.com/wiki/Disable_automatic_comment_insertion
""""""""""""""""""""

" For CPP only, for easier compiling and testing
autocmd BufEnter *.\(cpp\|h\|hpp\) silent! lcd %:p:h



"autocmd BufEnter *.md silent! lcd %:p:h " the problem is changing the working directory unattended
" only first line auto insert // not the following lines

autocmd FileType c,cpp setlocal comments-=:// comments+=f://
" column jump with zz re-centering
autocmd FileType md silent! setlocal nolist
autocmd BufEnter *.md silent! nnoremap <silent> <C-k> :call search('\%' . virtcol('.') . 'v\S', 'bW')<CR>zz
autocmd BufEnter *.md silent! nnoremap <silent> <C-j> :call search('\%' . virtcol('.') . 'v\S', 'W')<CR>zz

autocmd FileType python set shiftwidth=4
autocmd FileType python set tabstop=4
autocmd FileType python set softtabstop=4


" spelling enabled for markdown and git commit
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.md setlocal spellfile=~/markdown.en.utf-8.add
autocmd FileType gitcommit setlocal spell
autocmd FileType gitcommit setlocal spellfile=~/markdown.en.utf-8.add

""""""""""""""""""""
"
" Ultisnips
"
""""""""""""""""""""

" all need to take effect during insert mode the default keymap in help manual is not applicable
" (conflicts to Konsole shortcuts/insert mode keymaps) to my environments, setting to:
let g:UltiSnipsListSnippets="<c-h>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

""""""""""""""""""""
"
" Abbreviation
"
""""""""""""""""""""


" check inoreab and cnoreab, there are full-id, end-id, non-id types of lhs, keyword are just
" 'abc123' but not special characters :#+/\.
ab a2z abcdefghijklmnopqrstuvwxyz
ab z2a zyxwvutsrqponmlkjihgfedcba
inoreab vim2x2grid ┌───┬───┐<CR>│   │   │<CR>├───┼───┤<CR>│   │   │<CR>└───┴───┘
inoreab zall ∀
inoreab zex ∃
inoreab znex ∄
inoreab z1s ₁
inoreab z2s ₂
" Boolean, Integer, Rational, Real, Complex, Quaterion, Prime
inoreab zB 𝔹  | inoreab zI ℤ  | inoreab zQ ℚ  | inoreab zR ℝ  | inoreab zC ℂ
inoreab zQ ℍ  | inoreab zP ℙ  | inoreab zas ₐ | inoreab zes ₑ | inoreab zhs ₕ
inoreab zis ᵢ | inoreab zjs ⱼ | inoreab zks ₖ | inoreab zls ₗ | inoreab zms ₘ
inoreab zns ₙ | inoreab zos ₒ | inoreab zps ₚ | inoreab zrs ᵣ | inoreab zss ₛ
inoreab zts ₜ | inoreab zus ᵤ | inoreab zvs ᵥ | inoreab zxs ₓ |

inoreab zaS ᵃ | inoreab zbS ᵇ | inoreab zcS ᶜ | inoreab zdS ᵈ | inoreab zeS ᵉ
inoreab zfS ᶠ | inoreab zgS ᵍ | inoreab zhS ʰ | inoreab ziS ⁱ | inoreab zjS ʲ
inoreab zkS ᵏ | inoreab zlS ˡ | inoreab zmS ᵐ | inoreab znS ⁿ | inoreab zoS ᵒ
inoreab zpS ᵖ | inoreab zrS ʳ | inoreab zsS ˢ | inoreab ztS ᵗ | inoreab zuS ᵘ
inoreab zvS ᵛ | inoreab zwS ʷ | inoreab zxS ˣ | inoreab zyS ʸ | inoreab zzS ᶻ

inoreab zAS ᴬ | inoreab zBS ᴮ | inoreab zDS ᴰ | inoreab zES ᴱ | inoreab zGS ᴳ
inoreab zHS ᴴ | inoreab zIS ᴵ | inoreab zJS ᴶ | inoreab zKS ᴷ | inoreab zLS ᴸ
inoreab zMS ᴹ | inoreab zNS ᴺ | inoreab zOS ᴼ | inoreab zPS ᴾ | inoreab zRS ᴿ
inoreab zTS ᵀ | inoreab zUS ᵁ | inoreab zVS ⱽ | inoreab zWS ᵂ |

inoreab zM= ⎧<Down><Left>⎪<Down><Left>⎨<Down><Left>⎪<Down><Left>⎩
inoreab zM33 ⎧<Space>0<Space><Space>0<Space><Space>0<Space>⎫<Down><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>⎪<Space>0<Space><Space>0<Space><Space>0<Space>⎪<Down><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>⎩<Space>0<Space><Space>0<Space><Space>0<Space>⎭


""""""""""""""""""""
"
" surround
"
""""""""""""""""""""

"for django additional surrounding, more check `:help surround-customizing`


let g:surround_{char2nr("v")} = "{{ \r }}"
let g:surround_{char2nr("{")} = "{{ \r }}"
let g:surround_{char2nr("%")} = "{% \r %}"
let g:surround_{char2nr("#")} = "{# \r #}"
let g:surround_{char2nr("b")} = "{% block \1block name: \1 %}\r{% endblock \1\1 %}"
let g:surround_{char2nr("i")} = "{% if \1condition: \1 %}\r{% endif %}"
let g:surround_{char2nr("w")} = "{% with \1with: \1 %}\r{% endwith %}"
let g:surround_{char2nr("f")} = "{% for \1for loop: \1 %}\r{% endfor %}"
let g:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"

""""""""""""""""""""
"
" Text Objects: CamelCaseMotion
"
""""""""""""""""""""

map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

""""""""""""""""""""
"
" vim-airline or nvim-lualine
"
""""""""""""""""""""
if !has('nvim')
  let g:airline_theme='simple'

  " Let vim-airline to turn on vim-tagbar
  let g:airline#extensions#tagbar#enabled = 1

  " related to https://vi.stackexchange.com/questions/37577/changing-airline-vim-z-section?rq=1
  " if !exists('g:airline_symbols')
  "   let g:airline_symbols = {}
  " endif

  "let g:airline_symbols.colnr = '  ㏇:'
  "let g:airline_section_y = airline#section#create_right(['ffenc','BN: %{bufnr("%")}'])
else
  command! -nargs=? TabRename LualineRenameTab <args>
endif


""""""""""""""""""""
"
" ctags things, tagbar, gutentags
"
""""""""""""""""""""



set tags=./.tags;,.tags
"set tags=''

"for debugging
"let g:gutentags_trace=1
let g:gutentags_project_root = ['./.git;,.git']

let g:gutentags_ctags_auto_set_tags=0 "as the auto_set_tags wipe out project-based setting about ctags opt, djangoThings
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_ctags_exclude = ['node_modules','site_packages']

"the tags are generated from at ~/.cache/tags/ folder, each repo's tag is directory path.tag
"let s:vim_tags = expand('~/.cache/tags')
"let g:gutentags_cache_dir = s:vim_tags

"let g:gutentags_ctags_extra_args = ['--languages=markdown,python']
let g:gutentags_ctags_extra_args = ['--languages=markdown']

" https://pavelespinal.com/short-articles/vim-gutentags-ignoring-exclude-parameters-from-ctags/

" for exclude option, use the below but not let g:gutentags_ctags_extra_args += ['--exclude="*.json"']
"let g:gutentags_ctags_exclude = ['MaybeABSorRELpath'] "do it inside the repo

" for gutentags c++
"let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
"let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
"let g:gutentags_ctags_extra_args += ['--c-kinds=+px']



nmap <F2> :TagbarToggle<CR>
" Keymap Keyremap asd81923
" <C-m> and <C-j> just use <CR>
imap <C-@> <Nop>
imap <C-c> <Nop>
" imap <C-i> <Nop> " but cannot do, <Tab> become <Nop>
imap <C-j> <Nop>
" imap <C-g> <Nop> " may be useful for <C-g>u
" imap <C-m> <Nop> # but cannot do, <CR> no working
imap <C-q> <Nop>
imap <Del> <Nop>
