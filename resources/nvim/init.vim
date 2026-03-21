runtime common.vim
" override those not compatible with vim's, eg:
set undodir=~/.config/nvim/undodir

" vim
set nofoldenable
""""""""""""""""""""
"
" Colorscheme
"
""""""""""""""""""""
" For more info, `:help colorscheme`

autocmd vimenter * ++nested colorscheme gruvbox-material




" used lualine
runtime bufsMng.vim


" For .config files with vim modeline on first line
autocmd BufReadPost *.config if getline(1) =~ '" vim:' | set ft=vim | endif

""""""""""""""""""""
"
" Abbreviation
"
""""""""""""""""""""

noreab zlipsum <C-r>=fake#gen('lipsum')<cr>

lua require('init')



""""""""""""""""""""
"
" vim-fake: https://github.com/tkhren/vim-fake
"
" some basic usage:
" in insert mode: <c-r>=fake#gen('nonsense')
" :put=fake#gen(\"nonsense\")
""""""""""""""""""""

"" Get a nonsense text like Lorem ipsum
call fake#define('sentense', 'fake#capitalize('
                        \ . 'join(map(range(fake#int(3,15)),"fake#gen(\"nonsense\")"))'
                        \ . ' . fake#chars(1,"..............!?"))')

call fake#define('paragraph', 'join(map(range(fake#int(3,10)),"fake#gen(\"sentense\")"))')

"" Alias
call fake#define('lipsum', 'fake#gen("paragraph")')



""""""""""""""""""""
"
" Copilot
"
""""""""""""""""""""

if has('macunix')
  " Option+? — suggest
  imap <silent> ¿ <Plug>(copilot-suggest)
  " Option+] — next
  imap <silent> ' <Plug>(copilot-next)
  " Option+[ — previous
  imap <silent> " <Plug>(copilot-previous)
  " Option+w — accept word
  imap <silent> ∑ <Plug>(copilot-accept-word)
  " Option+l — accept line
  imap <silent> ¬ <Plug>(copilot-accept-line)
  " Option+d — dismiss
  imap <silent> ∂ <Plug>(copilot-dismiss)
else
  imap <silent> <A-/> <Plug>(copilot-suggest)
  imap <silent> <A-]> <Plug>(copilot-next)
  imap <silent> <A-[> <Plug>(copilot-previous)
  imap <silent> <A-w> <Plug>(copilot-accept-word)
  imap <silent> <A-l> <Plug>(copilot-accept-line)
  imap <silent> <A-d> <Plug>(copilot-dismiss)
endif


""""""""""""""""""""
"
" Neovim
"
""""""""""""""""""""

lua require('keyremap')


""""""""""""""""""""
"
" End of all
"
""""""""""""""""""""
let mapleader = "" " turn off mapleader after all plugins have loaded
