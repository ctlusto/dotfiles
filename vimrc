" Plugin setup
call plug#begin('~/.local/share/nvim/plugged')
set nocompatible
filetype off
set t_Co=256

Plug 'Raimondi/delimitMate' " Better matching for delimiters
Plug 'tpope/vim-unimpaired' " Pairs of useful mappings
Plug 'sheerun/vim-polyglot' " Support for a bunch of languages
Plug 'mattn/emmet-vim' " Emmet functionality
Plug 'tpope/vim-surround' " Surround text with stuff (quotes, braces, etc.)
Plug 'tpope/vim-repeat' " Repeat entire plugin maps, not just their native commands
Plug 'numToStr/Comment.nvim' " Commenting
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'tpope/vim-rhubarb' " Open files on GitHub
Plug 'niftylettuce/vim-jinja' " nunjucks syntax highlighting
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'milkypostman/vim-togglelist' " Toggle quickfix
Plug 'kyazdani42/nvim-web-devicons' " Filetype icons for Telescope
Plug 'lukas-reineke/indent-blankline.nvim' " Show indent guides
Plug 'neovim/nvim-lspconfig' " Configure language servers
Plug 'nvim-lua/popup.nvim' " Use popups
Plug 'nvim-lua/plenary.nvim' " Helpers for various plugins
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Parsing support
Plug 'nvim-telescope/telescope.nvim' " Picker/finder
Plug 'lewis6991/gitsigns.nvim', { 'branch': 'main' }
Plug 'hoob3rt/lualine.nvim' " Status line
Plug 'hrsh7th/nvim-compe' " Completion
Plug 'voldikss/vim-floaterm' " Floating terminal

" Typescript
Plug 'peitalin/vim-jsx-typescript' " TSX
Plug 'pangloss/vim-javascript' " Indentation, etc. for JS

" Themes
Plug 'EdenEast/nightfox.nvim', { 'branch': 'main' }

call plug#end()

" Mapleader
let mapleader = " "

""""""""""""""""""""""
" Plugin configuration

" Telescope stuff
nnoremap <C-p> :lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg :lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fc :lua require('telescope.builtin').grep_string()<cr>
nnoremap <leader>ff :lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false}

lua << EOF
require('telescope').setup{
  defaults = {
    path_display = { "truncate" }
  }
}

local nightfox = require('nightfox')
nightfox.setup({
  fox = "nordfox",
  styles = {
    comments = "italic",
    keywords = "bold",
    functions = "italic,bold"
  }
})
nightfox.load()

require("indent_blankline").setup()

require'lualine'.setup{
  options = { theme = 'nightfox' },
  sections = {
    lualine_c = { {'filename', path = 1 } },
    lualine_x = { 'encoding', 'filetype' }
    }
}

require('gitsigns').setup()
require('Comment').setup()

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}

-- Completion setup
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    nvim_lsp = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references
local nvim_lsp = require('lspconfig')
-- Gutter icons for LSP
vim.fn.sign_define("DiagnosticSignError",
    {text = "", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn",
    {text = "", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInformation",
    {text = "", texthl = "DiagnosticSignInformation"})
vim.fn.sign_define("DiagnosticSignHint",
    {text = "", texthl = "DiagnosticSignHint"})

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF

" Expand carriage returns in matching delimiters
let g:delimitMate_expand_cr=1

" Status line
set laststatus=2

" Gutter info behavior/styling
set updatetime=250

" The netrw banner is annoying
let g:netrw_banner=0

" Hitting gx instead of gc is almost always an error
let g:netrw_nogx=1

" Fugitive
nnoremap <leader>gs :Git<cr>
nnoremap <leader>gb :G blame<cr>
nnoremap <leader>gh :GBrowse<cr>
vnoremap <leader>gh :GBrowse<cr>
nnoremap <leader>gp :Git push<cr>

" Format JSON
" nnoremap <leader>jq :%!jq .<cr>

""""""""""""""""""
" End plugin stuff
""""""""""""""""""

"""""""""""""""
" General stuff
"""""""""""""""

" Clipboard
set clipboard=unnamed

"Python support
let g:python_host_prog = '/Users/chris/.pyenv/shims/python2'
let g:python3_host_prog = '/Users/chris/.pyenv/shims/python'

" Editing and sourcing .vimrc
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Avoid carpal tunnel syndrome
inoremap jk <esc>

" Fast saving
nnoremap <leader>w :w!<cr>

" Open a floating terminal
nnoremap <leader>t :FloatermToggle<cr>

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
nnoremap <silent> <cr> :noh<cr>

" Big left and big right
nnoremap H ^
nnoremap L $

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
set rnu
nnoremap <silent> <leader>r :set rnu!<cr>

" Keep some padding above/below when scrolling
set scrolloff=7

" Enable code folding based on syntax
set foldmethod=indent " Setting this to 'syntax' leads to gross performance
set nofoldenable " Have folding off by default

set signcolumn=yes

""""""""""""""""
" Colors and such
"""""""""""""""""
set termguicolors

" Enable syntax highlighting
syntax enable

" Recognize .underscore files as html
augroup filetypedetect
  au BufRead,BufNewFile *.underscore set filetype=html
augroup END

" Line numbers
set cursorline
set cursorcolumn

" Highlight column 80
set colorcolumn=80

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

" Line break on 80 characters
set lbr
set tw=80

" Auto indent
set ai

" Smart indent
set si

" Wrap lines
set wrap

" Fixes comments always getting outdented in Python
au! FileType python setl nosmartindent

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

"""""""""""""""""
" Merge conflicts
"""""""""""""""""
nnoremap <leader>dgf <cmd>diffget //2<cr>
nnoremap <leader>dgj <cmd>diffget //3<cr>
