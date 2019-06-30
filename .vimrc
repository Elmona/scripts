" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')
  Plug 'itchyny/lightline.vim'
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'pangloss/vim-javascript'
  Plug 'mxw/vim-jsx'
  Plug 'w0rp/ale'
  Plug 'junegunn/fzf'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'tpope/vim-surround'
  Plug 'gabrielelana/vim-markdown'
  Plug 'heavenshell/vim-jsdoc'
  Plug 'easymotion/vim-easymotion'
  Plug 'airblade/vim-gitgutter'
call plug#end()

" Settings
let mapleader=" "
set number relativenumber

map <C-l> dd
imap jj <Esc>

au FocusGained,BufEnter * :silent! wa
" au FocusLost,WinLeave * :silent! w

set timeout timeoutlen=1000 ttimeoutlen=300

" Set autoreload of files
:set autoread

" Easymotion
nmap s <Plug>(easymotion-overwin-f)

" JsDOC
map <leader>j :JsDoc<cr>
let g:jsdoc_enable_es6 = 1

" vim-markdown
let g:markdown_enable_spell_checking = 0

" pangloss/vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_conceal_arrow_function = "⇒"

" ctrlpvim
set wildignore+=*/node_modules/*
let g:ctrlp_open_new_file = 't'
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
    \ 'AcceptSelection("t")': ['<cr>'],
    \ }

let g:ctrlp_match_window = 'top,order:btt,min:1,max:15,results:10'
let g:ctrlp_show_hidden = 1

" w0rp/ale linter options
" let g:ale_completion_enabled = 1
let b:ale_linters = {'javascript': ['standard', 'eslint']}
let b:ale_fixers = {'javascript': ['standard', 'eslint']}
let g:fixmyjs_engine = 'eslint'

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

" Nerdtree
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-o> :NERDTree<CR>

" For lightline plug
set laststatus=2

" Auto expand tabs to spaces (use space rather than tab)
set expandtab
set shiftwidth=2
set tabstop=2

" Copy visual to clipboard
map <leader>y :'<,'> :w !xclip -selection clipboard<cr><cr>

" Go to file new in new tab
map <leader>gf <c-w>gf

" Open ~/.vimrc
map <leader>v :tabe ~/.vimrc<cr>
map <leader>V :source ~/.vimrc<cr>
map <leader>z :tabe ~/.zshrc<cr>

" Move to window
map <leader>w <C-w>

" Save and quit
map <leader>s :w<cr>
map <leader>q :q<cr>
map <leader>Q :qa!<cr>
map <leader>a :wq<cr>

" Switch tab
map <C-j> gT
map <C-k> gt
map <C-g> :tabm +1<cr>
map <C-h> :tabm -1<cr>

" New empty lines
map <leader><Enter> O<Esc>
map <Enter> o<Esc>

" Macro
let @b="i{\<cr>jj$i}jji\<cr>jjkw"

map <leader>. :s/\([a-z]\)\([A-Z]\)/\U\1_\U\2/g<cr>gvwU

" Merge conflicts
if &diff
    map <leader>1 :diffget LOCAL<CR>
    map <leader>2 :diffget BASE<CR>
    map <leader>3 :diffget REMOTE<CR>
endif
" Run program
" map <leader>r :!npm start<cr>
" map <leader>r :!./%<cr>
map <leader>r :!node %<cr>
" map <leader>r :!./test.sh<cr>
" map <leader>r :!python %<cr>
