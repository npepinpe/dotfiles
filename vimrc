set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" custom plugins
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'elzr/vim-json'
Plugin 'KeitaNakamura/neodark.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'airblade/vim-gitgutter'

Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'

Plugin 'rking/ag.vim'
Plugin 'tomtom/tlib_vim'
Plugin 'nathanaelkane/vim-indent-guides'

call vundle#end()

" Use the |:sign| interface to mark syntax errors
let g:syntastic_enable_signs=1
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_args='--max-complexity=10'

" When set to 1 the error window will be automatically
" opened when errors are detected, and closed when none
" are detected.
let g:syntastic_auto_loc_list=0

" Disable vim-json concealing - we want to see the file as it is
let g:vim_json_syntax_conceal = 0

" ctrlp: ignore source control files
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" End plugin/bundle config

syntax on

filetype plugin indent on

set tabstop=2
set softtabstop=2
set shiftwidth=2
set textwidth=120
set smarttab
set expandtab
set smartindent
set ruler
set ttyfast
set autoread
set more
set number

" set encoding to utf-8
" (among other things, needed for nerdtree to avoid display issues)
set encoding=utf-8

" Highlight stuff we don't want
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/

highlight Tabs ctermbg=red guibg=red
match Tabs /\t/

highlight Mcharacter ctermbg=red guibg=red
match Mcharacter /<Ctrl-V><Ctrl-M>/

" Statusline
" https://github.com/pengwynn/dotfiles/blob/master/vim/vimrc.symlink#L160

" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" No annoying sound on errors
set noerrorbells
set novisualbell
set timeoutlen=500

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set matchtime=2

" Always display status line
set laststatus=2

" Remember the last 500 commands => q: to list them
set history=500

" Starting from vim 7.3 undo can be persisted across sessions
" http://www.reddit.com/r/vim/comments/kz84u/what_are_some_simple_yet_mindblowing_tweaks_to/c2onmqe
if has("persistent_undo")
    set undodir=~/.vim/undodir
    set undofile
endif

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \ exe "normal! g`\"" |
     \ endif

" Remember info about open buffers on close
set viminfo^=%

" colorschemes
set t_Co=256
silent! colorscheme neodark
let g:airline_theme = 'neodark'
