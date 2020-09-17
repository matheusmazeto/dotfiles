syntax on
filetype off

" plugins
call plug#begin()

"Search
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

"Dashboard
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'

"Git
Plug 'tpope/vim-fugitive'

"Themes
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim', { 'as': 'dracula' }

"Icons
Plug 'ryanoasis/vim-devicons'

"Code
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

"Code formater
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

call plug#end()

set background=dark
let g:airline_theme='dracula'

syntax enable
colorscheme dracula

" Few configurations:
set hlsearch " Highlight search results
set encoding=UTF-8
set ffs=unix,dos,mac
set modeline
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set number
set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Search ===========================
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" ================ Completion =======================
set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" CtrlP to ignore
set wildignore+=*.swp,*.pyc
let g:ctrlp_show_hidden = 1

" NerdTree show hidden files
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.swp$', '\.pyc$']

" Short cuts:
let mapleader=","
map ; :Files<CR>
map <C-]> :NERDTreeToggle<CR>
"map <C-F> :NERDTreeFind<CR>         " Open NERDTree and focus on current file

set guifont=JetBrainsMono\ Nerd\ Font\ Regular\ 19

if (has("termguicolors"))
 set termguicolors
endif

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
