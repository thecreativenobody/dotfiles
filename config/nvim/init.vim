" =============================================================
" Arnold Chand
" https://github.com/creativenull
" (neo)vim config
" =============================================================
filetype plugin indent on

" Global variable to use for config
" ---
let g:python3_host_prog = $PYTHON3_HOST_PROG
let g:python_host_prog = $PYTHON_HOST_PROG
let g:plugins_dir = $NVIMRC_PLUGINS_DIR
let g:config_dir = $NVIMRC_CONFIG_DIR

" =============================================================
" = Plugin Manager =
" =============================================================
call plug#begin(g:plugins_dir)

" Core
Plug 'Shougo/context_filetype.vim'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'jremmen/vim-ripgrep'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tyru/caw.vim'

" Theme, Syntax
Plug 'ap/vim-buftabline'
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'sheerun/vim-polyglot'
Plug 'yggdroot/indentline'

call plug#end()

" =============================================================
" = Plugin Options =
" =============================================================
" --- ALE Options ---
call ale#linter#Define('php', {
\   'name': 'intelephense',
\   'lsp': 'stdio',
\   'executable': 'intelephense',
\   'command': '%e --stdio',
\   'project_root': function('ale_linters#php#langserver#GetProjectRoot')
\ })

" ALE general config
let g:ale_fix_on_save = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_hover_cursor = 0
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 100
let g:ale_completion_max_suggestions = 10
let g:ale_completion_autoimport = 1

" ALE linters config
let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'css': ['stylelint'],
\   'javascript': ['tsserver', 'eslint'],
\   'javascriptreact': ['tsserver', 'eslint'],
\   'php': ['intelephense'],
\   'scss': ['stylelint'],
\   'typescript': ['tsserver', 'eslint'],
\   'typescriptreact': ['tsserver', 'eslint'],
\   'vue': ['vls', 'eslint']
\ }

" ALE fixers config
let g:ale_fixers = {
\   '*': ['trim_whitespace', 'remove_trailing_lines']
\ }

" --- Fuzzy Finder Options ---
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" --- vim-polyglot Options ---
let g:vue_pre_processors = ['typescript', 'scss']

" --- Emmet ---
let g:user_emmet_leader_key = '<C-z>'

" --- Lightline Options ---
let g:lightline = {
\   'colorscheme': 'default',
\   'component': { 'line': 'LN %l/%L' },
\   'component_function': {
\       'gitbranch': 'gitbranch#name',
\       'lsp': 'LSP_StatueLine'
\   },
\   'active': {
\       'left': [ [ 'mode', 'paste' ], [ 'gitbranch' ] ],
\       'right': [ [ 'lsp' ], [ 'line' ], [ 'filetype' ] ]
\   }
\ }

" --- vim-buftabline Options ---
let g:buftabline_show = 1
let g:buftabline_indicators = 1

" =============================================================
" = General =
" =============================================================
set nocompatible
set encoding=utf8

" Completion options
set completeopt=menu,preview,longest,menuone,noinsert,noselect
set shortmess+=c
" set omnifunc=ale#completion#OmniFunc

" Search options
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan

" Indent options
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set autoindent
set smartindent

" Line options
set showmatch
set linebreak
set showbreak=+++
set textwidth=120
set colorcolumn=120
set scrolloff=3

" No backups or swapfiles needed
set nobackup
set nowritebackup
set noswapfile

" Lazy redraw
set lazyredraw

" Undo history
set undolevels=1000

" Buffers/Tabs/Windows
set hidden

" update time to 300ms
set updatetime=300

" Set spelling
set nospell

" For git
set signcolumn=yes

" Mouse support
set mouse=a

" File format type
set fileformats=unix

" no sounds
set visualbell t_vb=

" backspace behaviour
set backspace=indent,eol,start

" Status line
set noshowmode
set laststatus=2

" Tab line
set showtabline=2

" Better display
set cmdheight=2

" Auto reload file if changed outside vim, or just :e!
set autoread

" =============================================================
" = Functions =
" =============================================================
" Set any other options for dark theme
function! ThemeSetDark() abort
    let g:gruvbox_contrast_dark = 'hard'
    let g:gruvbox_sign_column = 'dark0_hard'
    let g:gruvbox_invert_selection = 0
    let g:gruvbox_number_column = 'dark0_hard'
endfunction

" Show the link parentheses and code blocks on markdown filetypes
function! MDSetNoConceal() abort
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_conceal_code_blocks = 0
endfunction

" LSP Setup
" ---
function! LSP_StatueLine() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '🟢' : printf(
        \   '%d 🔴 %d 🟡',
        \   all_errors,
        \   all_non_errors,
        \ )
endfunction

function! LSP_RegisterKeys() abort
    nmap <silent> <leader>ld :ALEGoToDefinition<CR>
    nmap <silent> <leader>lr :ALEFindReferences<CR>
    nmap <silent> <leader>lh :ALEHover<CR>
    nmap <silent> <F2> :ALERename<CR>
    nmap <silent> <leader>le :lopen<CR>
endfunction

" =============================================================
" = Auto Commands (single/groups) =
" =============================================================
" Show codeblocks, links in md files
augroup md_noconceal
    autocmd!
    autocmd FileType markdown call MDSetNoConceal()
augroup END

" =============================================================
" = Commands =
" =============================================================
command! Config edit $MYVIMRC

" =============================================================
" = Key Bindings =
" =============================================================
" Unbind default bindings for arrow keys, trust me this is for your own good
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>

inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Map Esc, to perform quick switching between Normal and Insert mode
inoremap jk <ESC>

" Map escape from terminal input to Normal mode
tnoremap <ESC> <C-\><C-n>
tnoremap <C-[> <C-\><C-n>

" Copy/Paste from the system clipboard
vnoremap <C-i> "+y<CR>
nnoremap <C-o> "+p<CR>

" File explorer
noremap <F3> :Ex<CR>

" Auto-completion
imap <C-Space> <C-x><C-o>

" Leader Map
let mapleader=' '

" Disable highlights
noremap <leader><CR> :noh<CR>

" Reload file
nnoremap <leader>r :e!<CR>

" Buffer maps
" ---
" List all buffers
nnoremap <leader>bl :buffers<CR>
" Create a new buffer
nnoremap <leader>bn :enew<CR>
" Go to next buffer
nnoremap <C-l> :bnext<CR>
" Go to previous buffer
nnoremap <C-h> :bprevious<CR>
" Close the current buffer
nnoremap <leader>bd :bp<BAR>sp<BAR>bn<BAR>bd<CR>

" Resize window panes, we can use those arrow keys
" to help use resize windows - at least we give them some purpose
nnoremap <up> :resize +2<CR>
nnoremap <down> :resize -2<CR>
nnoremap <left> :vertical resize -2<CR>
nnoremap <right> :vertical resize +2<CR>

" Text maps
" ---
" Move a line of text Alt+[j/k]
nnoremap <M-j> mz:m+<CR>`z
nnoremap <M-k> mz:m-2<CR>`z
vnoremap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

" Edit vimrc and gvimrc
nnoremap <leader>ve :e $MYVIMRC<CR>

" Source the vimrc to reflect changes
nnoremap <leader>vs :so $MYVIMRC<CR>:noh<CR>:EditorConfigReload<CR>

" Set LSP Keys
call LSP_RegisterKeys()

" =============================================================
" = Theming and Looks =
" =============================================================
syntax on
set number
set termguicolors
set relativenumber

call ThemeSetDark()
set background=dark
colorscheme gruvbox