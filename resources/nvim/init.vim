runtime common.vim
" dummy message
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






" add my custom buffers functions, does it require nvim?
" used lualine, may need airlone for vim
runtime bufsMng.vim


" For my .config project augmeneted configuration
autocmd BufReadPost *.config if getline(1) =~ '" vim:' | set ft=vim | endif

""""""""""""""""""""
"
" Plug Manager
"
""""""""""""""""""""

" plugin.vim https://github.com/junegunn/vim-plug
call plug#begin()

"For macOS problem, just use Lazy.nvim
"call :PlugInstall to install this
"" https://github.com/mg979/vim-visual-multi
"Plug 'mg979/vim-visual-multi', {'branch': 'master'}
"Plug 'sukima/xmledit'
"Plug 'tpope/vim-surround'
"Plug 'tpope/vim-repeat'
"Plug 'Asheq/close-buffers.vim', {'branch': 'master'}
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
"Plug 'bkad/CamelCaseMotion'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'preservim/tagbar'
"Plug 'ludovicchabant/vim-gutentags'

call plug#end()

""""""""""""""""""""
"
" Visual-Multi
"
""""""""""""""""""""













""""""""""""""""""""
"
" Ultisnips
"
""""""""""""""""""""




""""""""""""""""""""
"
" Abbreviation
"
""""""""""""""""""""

" TODO for vim-fake too, https://gist.github.com/tkhren/9fbc7227c2e9d2f4319c
noreab zlipsum <C-r>=fake#gen('lipsum')<cr>

"this has been moved preceded, testing if the PlugManager caused hang issues
lua require('init')



""""""""""""""""""""
"
" xmlEdit
" basic use \5, \u, but autocomplete is replaced by ultisnips
""""""""""""""""""""

let g:loaded_xmledit = 1 "this effectively disable xmlEdit, since recently not using html
let g:xmledit_enable_html=0
" TODO there is a buggy problem with *.md also being affected if typed <tag>
" autocmd FileType markdown let g:xmledit_enable_html=0 "once entering a markdown buffer, all buffer will have this var changed
"let g:dummy=123
"autocmd FileType markdown let b:dummy=345 #as wished buffers has its own version of dummy, but need b:





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
  "it is reverse of the default i_<c-]> for dismissing the suggestion
  " ?
  imap <silent> ¿ <Plug>(copilot-suggest)
  " ]
  imap <silent> ‘ <Plug>(copilot-next)
  " [
  imap <silent> “ <Plug>(copilot-previous)
  " w
  imap <silent> ∑ <Plug>(copilot-accept-word)
  " l
  imap <silent> ¬ <Plug>(copilot-accept-line)
  " d
  imap <silent> ∂ <Plug>(copilot-dismiss)
else
  " ?
  imap <silent> <A-/> <Plug>(copilot-suggest)
  " ]
  imap <silent> <A-]> <Plug>(copilot-next)
  " [
  imap <silent> <A-[> <Plug>(copilot-previous)
  " w
  imap <silent> <A-w> <Plug>(copilot-accept-word)
  " l
  imap <silent> <A-l> <Plug>(copilot-accept-line)
  " d
  imap <silent> <A-d> <Plug>(copilot-dismiss)
endif


""""""""""""""""""""
"
" Neovim
"
""""""""""""""""""""

"The |'ttymouse'| option, for example, was removed from Nvim (mouse support
"should work without it). If you use the same |vimrc| for Vim and Nvim,
"consider guarding |'ttymouse'| in your configuration like so:
" if !has('nvim')
"     set ttymouse=xterm2
" else
"     set mouse=a
" endif

"You just need to add a file $NVIM_FOLDER/lua/config.lua and lua require('config') in your init.vim.
"init.lua, the entry lua for all other .lua
"lua require('init')
"lua require('tutorial')
lua require('keyremap')

" single line lua
" lua print("hello world")

" multiline to call lua
lua << EOF
--require'lspconfig'.solargraph.setup{}
--require'lspconfig'.tsserver.setup{}

EOF


""""""""""""""""""""
"
" Neovim: Telescope extended docs search
"
""""""""""""""""""""

runtime extended_docs.vim


""""""""""""""""""""
"
" End of all
"
""""""""""""""""""""
let mapleader = "" "Ptts: turn off mapleader for other on-going loading plugins, otherwise keystroke freezing
