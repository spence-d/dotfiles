set nocompatible
if &t_Co > 2 || has("gui_running")
  " Enable syntax highlighting
  syntax on
endif
filetype plugin on
set encoding=utf8

"Mouse enabled in all modes
set mouse=a
"Special behavior for different button clicks, dragging, shift-clicks.
behave xterm

"Yank and paste using the OS clipboard
if has('unnamedplus')
    "On X11, yanks and deletions go to copy clipboard "+, and
    " visual selections go to the selection buffer "*
    set clipboard=unnamedplus,autoselect
else
    "Otherwise, just send everything to the clipboard "* and ignore selections
    set clipboard=unnamed
endif

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

"Use a better alternative for :grep
if executable("rg")
set grepprg=rg\ --vimgrep\ --auto-hybrid-regex\ --ignore-file\ ~/dotfiles/.gitignore
else
set grepprg=git\ grep\ -n\ $*
endif

"Persistent undos
set undofile
set undodir=~/.vim/undos

"Change leader character from \ to space.
let mapleader=" "

"Configure plugins with Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'

    "Git integration
    Plugin 'tpope/vim-fugitive'

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
    "Traverse tab menu from top to bottom
    let g:SuperTabDefaultCompletionType = "<c-n>"
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
    Plug 'neoclide/coc.nvim', {'branch': 'release', 'tag': 'v0.0.80'}
    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gr <Plug>(coc-references)
    " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)
        "Workaround for weirdness selecting snippets
    "Requires plugin coc-snippets
    imap <C-j> <Plug>(coc-snippets-expand-jump)
        "Shortcut to switch between header and source file
        "map <C-h> :CocCommand clangd.switchSourceHeader<CR>
    "coc-git keybindings:
        " navigate chunks of current buffer
        nmap [g <Plug>(coc-git-prevchunk)
        nmap ]g <Plug>(coc-git-nextchunk)
        " navigate conflicts of current buffer
        nmap [c <Plug>(coc-git-prevconflict)
        nmap ]c <Plug>(coc-git-nextconflict)
        " show chunk diff at current position
        nmap gs <Plug>(coc-git-chunkinfo)
        " show commit contains current position
        nmap gc <Plug>(coc-git-commit)
        " create text object for git chunks
        omap ig <Plug>(coc-git-chunk-inner)
        xmap ig <Plug>(coc-git-chunk-inner)


    "Highlights current paragraph
    Plug 'junegunn/limelight.vim'
        let g:limelight_conceal_ctermfg = 'gray'

    "Fuzzy finder
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
        "Find files in cwd
        map <Leader>ff :Files<CR>
        map <C-@> :Files<CR>
        "Find modified files in current git repo
        map <Leader>fg :GFiles?<CR>
        "Find in ctags
        map <Leader>ft :Tags<CR>
        "Find in ex history
        map <Leader>fh :History:<CR>
        "Find in open buffers
        map <Leader>fb :Buffers<CR>
        "Find in files using ripgrep
        map <Leader>fr :Rg<CR>

    "Wiki-like note taking
    Plug 'vimwiki/vimwiki'

    "Bracketing macros
    Plug 'tpope/vim-surround'

    Plug 'tomasr/molokai'

    "Bold/underline unique letters for jumping
    Plug 'unblevable/quick-scope'

  "Lightweight C++ syntax highlighting
    Plug 'bfrg/vim-cpp-modern'
call plug#end()

"Colors and margins
colorscheme molokai
"Adds a margin with line numbers relative to the current line
set number relativenumber
"Merge gutter and line numbers
"set signcolumn=number
highlight LineNr ctermfg=8 ctermbg=233
"Highlights the current line
set cursorline
set cursorlineopt=number,screenline
"highlight CursorLine cterm=bold
"Adds a guiding line at column 80 (or whatever textwidth is set to)
set colorcolumn=+0
highlight Normal ctermbg=0
highlight ColorColumn ctermbg=232
highlight CursorLine ctermbg=232
highlight CursorLineNr cterm=bold ctermfg=white ctermbg=232
highlight SignColumn ctermbg=234
highlight Folded ctermbg=236
highlight DiffAdd ctermbg=17
highlight DiffChange ctermbg=54
highlight DiffText ctermbg=52
highlight QuickScopePrimary cterm=bold
highlight QuickScopeSecondary cterm=underline
if index(['qf', 'help', 'fugitive'], &filetype) >= 0
    setlocal textwidth=0
else
    setlocal textwidth=80
end

"cscope functionality
if filereadable("cscope.out")
    "set cst
    cs add cscope.out
endif
"Find calls to function under cursor with cscope
map <F1> lb"zyw:cs f c <C-r>z<CR>

"Grep word under cursor
map <F2> lb"zyw:grep <C-r>z<CR>

"Generic save-and-run command.
"If it's not an independently executable script, override it by filetype.
map <F4> :w\|!./%<CR>
autocmd FileType vim map <F4> :w\|source %<CR>

"%% in command mode expands to the directory path of the current file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
cnoremap %. <C-R>=fnameescape(expand('%:r')).'.'<cr>
"Copy to the end of line
map Y y$
"Format the current function
map gqp [[v%o-gq
