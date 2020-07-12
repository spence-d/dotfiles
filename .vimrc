set nocompatible
if &t_Co > 2 || has("gui_running")
  " Enable syntax highlighting
  syntax on
endif
filetype plugin on
set encoding=utf8

"Colors and margins
colorscheme elflord
"Adds a margin with line numbers relative to the current line
set number relativenumber
highlight LineNr ctermfg=8
"Highlights the current line
set cursorline
highlight CursorLine ctermbg=234 cterm=none
"Adds a guiding line at column 80
set colorcolumn=80
highlight ColorColumn ctermbg=232
highlight CursorLineNr cterm=bold ctermfg=white ctermbg=232
highlight Folded ctermbg=236

"Mouse enabled in all modes
set mouse=a
"Special behavior for different button clicks, dragging, shift-clicks.
behave xterm

"Yank and paste using the OS clipboard
set clipboard=unnamed

"Tabs/indentation
"Tab key inserts 2 spaces
set expandtab tabstop=2
"Indent with 2 spaces
set shiftwidth=2
"F10 temporarily disables autoindent
set pastetoggle=<F10>
"gq command pipes through this formatter
set formatprg=astyle
"Indentation rules for C-like languages
"Align C case labels with their enclosing brackets
"Align C++ scope declarations with their brackets
"Align with enclosing open parenthesis
set cinoptions=:0,g0,(0

"Search
"Show search results while typing
set incsearch
"Highlight search results
set hlsearch

"Generate folds based on type of file
set foldmethod=syntax
"Leave everything unfolded on open (zM to fold all)
set nofoldenable

"Disable word wrapping
set nowrap
"Enable backspacing in all places
set backspace=2
"Autocomplete menu in command mode
set wildmenu
"Don't move current pane when splitting vertically
set splitright
"Enable syntax completion
set omnifunc=syntaxcomplete#Complete

"Use git-grep for :grep
set grepprg=git\ grep\ -n\ $*

"Change leader character from \ to space.
let mapleader=" "

"Configure plugins with Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'

    "Git integration
    Plugin 'tpope/vim-fugitive'
    "Git line change symbols in the margin
    Plugin 'airblade/vim-gitgutter'

    ":VimuxRunCommand opens small tmux pane
    Plugin 'benmills/vimux'
    "Mode-dependent cursor shapes
    Plugin 'wincent/terminus'
    ":Make runs :make asynchronously
    Plugin 'tpope/vim-dispatch'
    "\r to run Ruby tests
    Plugin 'skalnik/vim-vroom'
        let g:vroom_use_vimux = 1

    "Gives tab key autocomplete superpowers
    Plugin 'ervandew/supertab'
    "Keywords that autocomplete into common code
    Plugin 'honza/vim-snippets'

    "Overrides default directory view, :NERDtree shows tree-based file browser
    Plugin 'scrooloose/nerdtree'
        map <Leader>t :NERDTreeToggleVCS<CR>
    "File-extension-based coloring
    Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
    "Git icons for nerdtree
    Plugin 'xuyuanp/nerdtree-git-plugin'

    "Powerline-like status bars on the top and bottom
    Plugin 'bling/vim-airline' 
        let g:airline_powerline_fonts = 1
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
        set guifont=DroidSansMonoForPowerlinePlusNerdFileTypesMono:h11
    "Icons for nerdtree and airline
    Plugin 'ryanoasis/vim-devicons'

    "CoffeeScript support
    Plugin 'kchmck/vim-coffee-script'
call vundle#end()

"Configure plugins with vimplug
call plug#begin('~/.vim/plugged')
    "Completion engine
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
        "Workaround for weirdness selecting snippets
        imap <C-l> <Plug>(coc-snippets-expand)
        "Shortcut to switch between header and source file
        map <C-h> :CocCommand clangd.switchSourceHeader<CR>

    "Fuzzy finder
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
        "Find files in cwd
        map <Leader>ff :Files<CR>
        "Find modified files in current git repo
        map <Leader>fg :GFiles?<CR>
        "Find in ctags
        map <Leader>ft :Tags<CR>

    "Wiki-like note taking
    Plug 'vimwiki/vimwiki'
call plug#end()

"cscope functionality
if filereadable("cscope.out")
"	set cst
	cs add cscope.out
endif
"Find calls to function under cursor with cscope
map <F1> lb"zyw:cs f c <C-r>z<CR>

"Grep word under cursor
map <F2> lb"zyw:grep <C-r>z<CR>

"%% in command mode expands to the directory path of the current file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
"Copy to the end of line
map Y y$