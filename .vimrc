""""""""""""""""""""
"
" Vim
"
""""""""""""""""""""




if &compatible
  set nocompatible
endif



silent! while 0
  set nocompatible
silent! endwhile

filetype plugin on
  " :help ft-markdown-plugin
let g:markdown_folding = 1
"let g:markdown_recommended_style=0 " the Tim Pope ftp markdown.vim set shfitwidth=4
"let g:markdown_fenced_languages = ['python','html','java','bash=sh','css']

"good for :find, no need to use !find, the system's find cmd
"set path=.,/usr/include, "default setting, no need to specify comma
set path=.
set path+=**
set wildmenu

set incsearch
set hlsearch
"Since I really use /\c{pattern} a lot...as to use \c to search either "Big/small letter
set ignorecase
set smartcase "smartcase requires ignorecase
syntax on
set nu
"relativenumber take priority over `:set nu`,

"caused the current line marked as 0 instead of line number
set relativenumber

set nowrap
"useful when nowrap is set
set sidescrolloff=15

"wm is no good that, if I work on different OS, the margin is changing
"tw is better for standardization
"luckily, wrap margin(wm) has lower priority than text width (tw), check :help wm and :help tw
set wrapmargin=0
highlight ColorColumn ctermbg=magenta ctermfg=blue
"set colorcolumn=81
"match ColorColumn "\%101v."
match ColorColumn "\%>101v."
"colorcoumn is a good matched use with text width
set textwidth=100

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

autocmd vimenter * ++nested colorscheme gruvbox
"for vim only... setting spell style
autocmd vimenter * ++nested hi SpellBad cterm=underline
set background=dark

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






"use command FS to start a fixed width vertical netrw explorer
command! -nargs=* FS Vex | set wfw


"""""""""""""""""""""""
"
" Vim:Remapping keys
"
""""""""""""""""""""""

" +/- split windows size
map + <C-W>5>
map - <C-W>5<
map <PageDown> <C-w>5-
map <PageUp> <C-w>5+

nnoremap <silent> <C-y> 5<C-y>
nnoremap <silent> <C-e> 5<C-e>









nnoremap <silent> <C-k> :call search('\%' . virtcol('.') . 'v\S', 'bW')<CR>
nnoremap <silent> <C-j> :call search('\%' . virtcol('.') . 'v\S', 'W')<CR>













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

let mapleader = " "
" Terminal related
nnoremap <silent> <leader>t :terminal<CR>
nnoremap <silent> <leader>vt :vertical terminal<CR>
tnoremap <silent> <Esc> <C-\><C-n>
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


vnoremap <silent> J :move '>+1<CR>gv-gv
vnoremap <silent> K :move '<-2<CR>gv-gv











" https://vim.fandom.com/wiki/Redirect_g_search_output
command! -nargs=? Filter let @a='' | execute 'g/<args>/y A' | new | setlocal bt=nofile | put! a

" or :put=execute('PrintFilePath') for writing into buffer
command! PrintFilePath echo expand('%:p')
command! PutFilePath put=expand('%:p')


"move current line to the end of buffer without moving cursor
"if without such function, I would ":norm ddGp``" and @: and repeat by @@
let mapleader = "c"
nnoremap <leader>m :call MoveToEnd()<CR>

function! MoveToEnd()
  execute "normal! ddGp``"
endfunction

"copy current line to the end of buffer without moving cursor
nnoremap <leader>p YGp``


""""""""""""""""""""
"
" Vim:Vimgrep over opened buffers
"
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
command! -nargs=1 Move call AtomicRenameCurBuf(<f-args>)

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

" For Markdown , for easier compiling and testing, why? but it affects some function that require
" global project control, like `:find `
"autocmd BufEnter *.md silent! lcd %:p:h
" only first line auto insert // not the following lines

autocmd FileType c,cpp setlocal comments-=:// comments+=f://
" column jump with zz re-centering
autocmd FileType md silent! setlocal nolist
autocmd BufEnter *.md silent! nnoremap <silent> <C-k> :call search('\%' . virtcol('.') . 'v\S', 'bW')<CR>zz
autocmd BufEnter *.md silent! nnoremap <silent> <C-j> :call search('\%' . virtcol('.') . 'v\S', 'W')<CR>zz

autocmd FileType python set sw=2
autocmd FileType python set ts=2
autocmd FileType python set sts=2

" https://vim.fandom.com/wiki/Indenting_source_code#.27autoindent.27
" somehow in neovim the python indentation is 4 spaces, no good for screen to contain more information
"autocmd FileType python setlocal shiftwidth=2 tabstop=2

" spelling enabled for markdown and git commit
" autocmd BufRead,BufNewFile *.md setlocal spell
" autocmd BufRead,BufNewFile *.md setlocal spellfile=~/markdown.en.utf-8.add
" autocmd FileType gitcommit setlocal spell
" autocmd FileType gitcommit setlocal spellfile=~/markdown.en.utf-8.add


""""""""""""""""""""
"
" Plug Manager
"
""""""""""""""""""""

" plugin.vim https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

"call :PlugInstall to install this
" https://github.com/mg979/vim-visual-multi
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'sukima/xmledit'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
"Plug 'vim-scripts/taglist.vim'
Plug 'Asheq/close-buffers.vim', {'branch': 'master'}

Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
Plug 'bkad/CamelCaseMotion'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Asheq/close-buffers.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'preservim/tagbar'
Plug 'cespare/vim-toml', { 'branch': 'main' }
Plug 'morhetz/gruvbox'
Plug 'mattn/emmet-vim'




call plug#end()

""""""""""""""""""""
"
" Ultisnips
"
""""""""""""""""""""



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

" maybe interested, https://github.com/arthurxavierx/vim-unicoder#subscripts


ab a2z abcdefghijklmnopqrstuvwxyz
ab z2a zyxwvutsrqponmlkjihgfedcba
inoreab vim2x2grid ┌───┬───┐<CR>│   │   │<CR>├───┼───┤<CR>│   │   │<CR>└───┴───┘
noreab zall ∀
noreab zex ∃
noreab znex ∄
noreab z1s ₁
noreab z2s ₂
" Boolean, Integer, Rational, Real, Complex, Quaterion, Prime
inoreab zB 𝔹  | inoreab zI ℤ  | inoreab zQ ℚ  | inoreab zR ℝ  | inoreab zC ℂ  |
inoreab zQ ℍ  | inoreab zP ℙ  | noreab zas ₐ  | noreab zes ₑ  | noreab zhs ₕ  |
noreab zis ᵢ  | noreab zjs ⱼ  | noreab zks ₖ  | noreab zls ₗ  | noreab zms ₘ  |
noreab zns ₙ  | noreab zos ₒ  | noreab zps ₚ  | noreab zrs ᵣ  | noreab zss ₛ  |
noreab zts ₜ  | noreab zus ᵤ  | noreab zvs ᵥ  | noreab zxs ₓ  |

noreab zaS ᵃ  | noreab zbS ᵇ  | noreab zcS ᶜ  | noreab zdS ᵈ  | noreab zeS ᵉ  |
noreab zfS ᶠ  | noreab zgS ᵍ  | noreab zhS ʰ  | noreab ziS ⁱ  | noreab zjS ʲ  |
noreab zkS ᵏ  | noreab zlS ˡ  | noreab zmS ᵐ  | noreab znS ⁿ  | noreab zoS ᵒ  |
noreab zpS ᵖ  | noreab zrS ʳ  | noreab zsS ˢ  | noreab ztS ᵗ  | noreab zuS ᵘ  |
noreab zvS ᵛ  | noreab zwS ʷ  | noreab zxS ˣ  | noreab zyS ʸ  | noreab zzS ᶻ  |

noreab zAS ᴬ  | noreab zBS ᴮ  | noreab zDS ᴰ  | noreab zES ᴱ  | noreab zGS ᴳ  |
noreab zHS ᴴ  | noreab zIS ᴵ  | noreab zJS ᴶ  | noreab zKS ᴷ  | noreab zLS ᴸ  |
noreab zMS ᴹ  | noreab zNS ᴺ  | noreab zOS ᴼ  | noreab zPS ᴾ  | noreab zRS ᴿ  |
noreab zTS ᵀ  | noreab zUS ᵁ  | noreab zVS ⱽ  | noreab zWS ᵂ  |

noreab zM= ⎧<Down><Left>⎪<Down><Left>⎨<Down><Left>⎪<Down><Left>⎩
noreab zM33 ⎧<Space>0<Space><Space>0<Space><Space>0<Space>⎫<Down><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>⎪<Space>0<Space><Space>0<Space><Space>0<Space>⎪<Down><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>⎩<Space>0<Space><Space>0<Space><Space>0<Space>⎭

""""""""""""""""""""
"
" ctags things, tagbar, gutentags
"
""""""""""""""""""""
set tags=./.tags;,.tags
nmap <F2> :TagbarToggle<CR>
""""""""""""""""""""
"
" vim-airline
"
""""""""""""""""""""
let g:airline_theme='simple'

" Let vim-airline to turn on vim-tagbar
let g:airline#extensions#tagbar#enabled = 1

" related to https://vi.stackexchange.com/questions/37577/changing-airline-vim-z-section?rq=1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.colnr = '  ㏇:'


let g:airline_section_y = airline#section#create_right(['ffenc','BN: %{bufnr("%")}'])


""""""""""""""""""""
"
" xmlEdit
"
""""""""""""""""""""

let g:xmledit_enable_html=1

""""""""""""""""""""
"
" surround
"
""""""""""""""""""""




let g:surround_{char2nr("v")} = "{{ \r }}"
let g:surround_{char2nr("{")} = "{{ \r }}"
let g:surround_{char2nr("%")} = "{% \r %}"
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
" End of all
"
""""""""""""""""""""
let mapleader = ""
