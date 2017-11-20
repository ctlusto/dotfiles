" Plugin setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim' " Bundle manager
Plugin 'Raimondi/delimitMate' " Better matching for delimiters
Plugin 'ctrlpvim/ctrlp.vim' " Better file finding
Plugin 'Valloric/YouCompleteMe' " Autocompletion support
Plugin 'mhinz/vim-signify' " Git change information in the gutter
Plugin 'tpope/vim-fugitive' " Git wrapper 
Plugin 'easymotion/vim-easymotion' " Easy keyboard navigation
Plugin 'sheerun/vim-polyglot' " Support for a bunch of languages
Plugin 'vim-airline/vim-airline' " Nice status bar
Plugin 'vim-airline/vim-airline-themes' " Theming for the status bar
Plugin 'mattn/emmet-vim' " Emmet functionality
Plugin 'tpope/vim-surround' " Surround text with stuff (quotes, braces, etc.)
Plugin 'tpope/vim-repeat' " Repeat entire plugin maps, not just their native commands
Plugin 'tpope/vim-commentary' " Commenting

call vundle#end()

""""""""""""""""""""""
" Plugin configuration
""""""""""""""""""""""

" File finding
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Expand carriage returns in matching delimiters
let g:delimitMate_expand_cr=1

" Don't want annoying window in YCM
set completeopt-=preview
let g:ycm_add_preview_to_completeopt=0

" Airline theme
let g:airline_theme='molokai'
let g:airline#extension#tabline#enabled=1
let g:airline_powerline_fonts=1
set laststatus=2

" Make sure Signify doesn't check for a whole bunch of VCS
let g:signifS_vcs_list = ['git']
" Attempt to have Signify refresh when Vim gains focus
let g:signify_update_on_focusgained = 1

""""""""""""""""""
" End plugin stuff
""""""""""""""""""

"""""""""""""""
" General stuff
"""""""""""""""

" Mapleader
let mapleader = ","

" So you don't have to do <Leader><Leader> in easymotion
map <Leader> <Plug>(easymotion-prefix)

" Editing and sourcing .vimrc
nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Avoid carpal tunnel syndrome
inoremap jk <esc>

" Fast saving
nnoremap <leader>w :w!<cr>

" Force Signify to refresh git gutter info
nnoremap <silent> <leader>R :SignifyRefresh<cr>

" Always show the current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts the way it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Be smart about cases when searching
set ignorecase
set smartcase

" Make searching nicer
set hlsearch
set incsearch
" Clear search highlighting quickly
nnoremap <silent> <space> :noh<cr>

" Turn magic on for regexps
set magic

" Show matching brackets
set showmatch
set mat=2

" Silence annoyances
set noerrorbells
set novisualbell

" Line number stuff
set number
set foldcolumn=1
set numberwidth=1
nnoremap <silent> <leader>r :set rnu!<cr>

" Keep some padding above/below when scrolling
set scrolloff=7

" Enable code folding based on syntax
set foldmethod=indent " Setting this to 'syntax' leads to gross performance
set nofoldenable " Have folding off by default

""""""""""""""""
" Colors and such
"""""""""""""""""
" Use 256 colors
set t_Co=256

" Enable syntax highlighting
syntax enable

" Recognize .underscore files as html
augroup filetypedetect
  au BufRead,BufNewFile *.underscore set filetype=html
augroup END

" Color scheme
color monokai 
let g:monokai_term_italic=1

" Line numbers
set cursorline
highlight LineNr ctermfg=DarkGrey ctermbg=NONE
highlight CursorLine term=NONE cterm=NONE

" Highlight column 80
set colorcolumn=80
highlight ColorColumn ctermbg=237

"""""""""""""""""
" File encodings
"""""""""""""""""
set encoding=utf8
set ffs=unix,dos,mac


""""""""""""""""""""""
" Files, backups, undo
""""""""""""""""""""""
set nobackup
set nowb
set noswapfile

""""""""""""""""""""""
" Text, tabs, indents
""""""""""""""""""""""
filetype on
filetype plugin on
filetype indent on

" Tabs instead of spaces
set expandtab

" Be smart about tabs
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Line break on 500 characters
set lbr
set tw=500

" Auto indent
set ai

" Smart indent
set si

" Wrap lines
set wrap

"""""""""""""""""
" Navigate tabs
"""""""""""""""""
nnoremap <silent> <c-[> :tabprevious<cr>
nnoremap <silent> <c-]> :tabnext<cr>

"""""""""""""""""""""""""
" Create and close splits
"""""""""""""""""""""""""
nnoremap <silent> <leader>- :split<cr>
nnoremap <silent> <leader>\| :vsplit<cr>

""""""""""""""""""
" Navigate windows
""""""""""""""""""
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l




