set nocompatible
if &t_Co > 2 || has("gui_running")
  "Enable syntax highlighting
  syntax on
  "Enable true color
  set termguicolors
endif
filetype plugin on
set encoding=utf8

"Allow buffer-switching with pending changes
set hidden

"Mouse enabled in all modes
set mouse=a
"Special behavior for different button clicks, dragging, shift-clicks.
behave xterm

"Yank and paste using the OS clipboard
if has('unnamedplus')
    "On X11, yanks and deletions go to copy clipboard "+,
    " yanks will also go to the selection buffer for good measure, and
    " visual selections just go to the selection buffer "*
    set clipboard=unnamedplus,unnamed,autoselect
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
set ignorecase
set smartcase
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
    nmap <Leader><Leader>g :G<CR><C-w>10-
    nmap <Leader>gv :Gvdiff<CR>
    "Git commit tree browsing :GV and :GV!
    Plugin 'junegunn/gv.vim'

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
    "Plugin 'ervandew/supertab'
    "Enter selects menu item (which supertab broke)
    "inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
    "Traverse tab menu from top to bottom
    let g:SuperTabDefaultCompletionType = "<c-n>"
    "Keywords that autocomplete into common code
    Plugin 'honza/vim-snippets'

    "Overrides default directory view, :NERDtree shows tree-based file browser
    Plugin 'scrooloose/nerdtree'
        map <Leader>n :NERDTreeToggleVCS<CR>
    "File-extension-based coloring
    Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
    "Git icons for nerdtree
    Plugin 'xuyuanp/nerdtree-git-plugin'

    "Powerline-like status bars on the top and bottom
    Plugin 'bling/vim-airline'
        let g:airline_powerline_fonts = 1
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
        let g:airline#extensions#tabline#buffer_nr_show = 1
        "set guifont=DroidSansMonoForPowerlinePlusNerdFileTypesMono:h11
    "Icons for nerdtree and airline
    "Clearing t_RV is a workaround for a vim bug that prints lots of weird
    " characters when loading in kitty without tmux
    set t_RV=
    Plugin 'ryanoasis/vim-devicons'

    "CoffeeScript support
    Plugin 'kchmck/vim-coffee-script'
call vundle#end()

"Configure plugins with vimplug
call plug#begin('~/.vim/plugged')
    "Completion engine
    Plug 'neoclide/coc.nvim', {'branch': 'release', 'tag': 'v0.0.80'}
    inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" : "\<C-i>"
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ coc#refresh()
    "Use tab and enter for menu navigation
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    "Use the native tag stack bindings
    set tagfunc=CocTagFunc
    " GoTo code navigation.
    nmap <silent> <Leader>cd <Plug>(coc-definition)
    nmap <silent> <Leader>ci <Plug>(coc-implementation)
    nmap <silent> <Leader>cD <Plug>(coc-declaration)
    nmap <silent> <Leader>cc <Plug>(coc-references-used)
    vmap <leader>cf  <Plug>(coc-format-selected)
    nmap <leader>cf  <Plug>(coc-format-selected)
    nmap <leader>cx  <Plug>(coc-fix-current)
    nmap <Leader>cr <Plug>(coc-rename)
    nmap <Leader>cR <Plug>(coc-refactor)
    nmap <Leader>cn <Plug>(coc-diagnostic-next)
    nmap <Leader>cN <Plug>(coc-diagnostic-prev)
    nmap <Leader>ck :call CocActionAsync('doHover')<CR>
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)
    "Highlight references to the variable when the cursor rests on it
    map <Leader>ch :call CocActionAsync('highlight')<CR>
    autocmd CursorHold * silent call CocActionAsync('highlight')
    "Workaround for weirdness selecting snippets
    "Requires plugin coc-snippets
    let g:coc_snippet_next = '<Tab>'
    let g:coc_snippet_prev = '<S-Tab>'
    map <Leader>fs :CocList snippets<CR>
        "Shortcut to switch between header and source file
        map <Leader>ch :CocCommand clangd.switchSourceHeader<CR>
        "coc-git keybindings:
        " navigate chunks of current buffer
        nmap <Leader>gN <Plug>(coc-git-prevchunk)
        nmap <Leader>gn <Plug>(coc-git-nextchunk)
        " show chunk diff at current position
        nmap <Leader>gi <Plug>(coc-git-chunkinfo)
        " show commit contains current position
        nmap <Leader>gc <Plug>(coc-git-commit)
        " create text object for git chunks
        omap ig <Plug>(coc-git-chunk-inner)
        xmap ig <Plug>(coc-git-chunk-inner)
        nmap <Leader>gu :CocCommand git.chunkUndo<CR>
        nmap <Leader>gf :CocCommand git.foldUnchanged<CR>
        nmap <Leader>ga :CocCommand git.chunkStage<CR>

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
        "Find lines from selection buffer history
        command! -bang -nargs=? -complete=dir Clip call fzf#run(fzf#wrap({'source': 'greenclip print', 'sink': 'norm i'}, <bang>0))
        map <Leader>fc :Clip<CR>
    "Wiki-like note taking
    Plug 'vimwiki/vimwiki'

    "Bracketing macros
    Plug 'tpope/vim-surround'
    "Allows . (repeat) to work with the above plugin
    Plug 'tpope/vim-repeat'

    "Quick commenting: gc{motion}
    Plug 'tomtom/tcomment_vim'
    "No padding
    let g:tcomment#options = {'whitespace': 'no'}
    "Skip blank lines
    let g:tcomment#blank_lines = 0
    "Copy duplicate n lines as comments
    map gcy :<C-u>exec '.,.+'. (v:count1 - 1) . 'y\|put!\|.-' . (v:count1 - 1) . ',.TComment!'<CR>

    "Dark color theme
    Plug 'tomasr/molokai'
    Plug 'joshdick/onedark.vim'

    "Bold/underline unique letters for jumping
    Plug 'unblevable/quick-scope'
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

    "Lightweight C++ syntax highlighting
    "Plug 'jackguo380/vim-lsp-cxx-highlight'
    Plug 'bfrg/vim-cpp-modern'
    let g:cpp_member_highlight = 1
    let g:cpp_no_cpp20 = 1
    let g:cpp_no_boost = 1

    "Swap list elements
    Plug 'machakann/vim-swap'

    "Integration between vim and tmux split-pane navigation
    Plug 'christoomey/vim-tmux-navigator'
    "Make the navigation keys work in terminal panes
    tmap <C-h> <C-w>h
    tmap <C-j> <C-w>j
    tmap <C-k> <C-w>k
    tmap <C-l> <C-w>l
    tmap <C-\> <C-w>p

    "Floating terminal window
    Plug 'voldikss/vim-floaterm'
    map <Leader>t :FloatermNew<CR>
    autocmd FileType ruby map <Leader>t :FloatermNew irb<CR>
    autocmd FileType haskell map <Leader>t :FloatermNew ghci<CR>
    autocmd FileType python map <Leader>t :FloatermNew python<CR>
    autocmd FileType clojure map <Leader>t :FloatermNew clj<CR>
    autocmd FileType coffee map <Leader>t :FloatermNew coffee<CR>
    autocmd FileType javascript map <Leader>t :FloatermNew node<CR>
    let g:floaterm_autoclose = 1
    let g:floaterm_title = ""

    "Uniquely colored bracket pairs
    "Plug 'frazrepo/vim-rainbow'
    "let g:rainbow_guifgs = ['white', 'grey62', 'green4', 'deepskyblue3', 'purple', 'magenta', 'red', 'orange', 'yellow']
    Plug 'luochen1990/rainbow'
    let g:rainbow_active = 1
    let g:rainbow_conf = {
\     'guifgs': ['white', 'grey62', 'green4', 'deepskyblue3', 'purple', 'magenta', 'red', 'orange', 'yellow'],
\     'operators': '_,\|;\|+\|-\|\*\|%\|\.\|>\|<\|=\|!\||\|&\|\~\|\^\|?\|:_'
\   }
	"autocmd ColorScheme * RainbowToggleOn

    "Plug 'chrisbra/Colorizer'

    Plug 'easymotion/vim-easymotion'
	let g:EasyMotion_do_mapping = 0
	map <Leader><Leader>f <Plug>(easymotion-bd-W)
call plug#end()

"Colors and margins
colorscheme molokai
"colorscheme onedark
"Adds a margin with line numbers relative to the current line
set number relativenumber
"Merge gutter and line numbers
"set signcolumn=number
highlight LineNr guifg=#808080 guibg=#121212 ctermfg=8 ctermbg=233
"Highlights the current line
"set cursorline
set cursorlineopt=number,screenline
"Adds a guiding line at column 80 (or whatever textwidth is set to)
set colorcolumn=+0
highlight Normal guifg=NONE guibg=#000000 ctermbg=0
highlight ColorColumn guibg=#121212 ctermbg=233
highlight CursorLine guibg=NONE ctermbg=NONE
highlight CursorLineNr guibg=black guifg=green cterm=bold ctermbg=black ctermfg=green
highlight SignColumn guibg=#1c1c1c ctermbg=234
"highlight Folded guibg=#1c1c1c ctermbg=234
highlight clear MatchParen
highlight MatchParen cterm=bold
highlight DiffAdd ctermbg=17
highlight DiffChange ctermbg=54
highlight DiffText ctermbg=52
highlight String guifg=#2080ff ctermfg=blue cterm=bold
highlight Character guifg=#2080ff ctermfg=blue
highlight Function guifg=green ctermfg=green
highlight Type cterm=bold,italic
highlight Constant cterm=bold,italic
highlight Boolean cterm=bold,italic
highlight Comment cterm=italic guifg=#50a0a0 ctermfg=245
highlight Statement guifg=#c678dd ctermfg=170
highlight Conditional guifg=#c678dd ctermfg=170
"autocmd FileType cpp syntax match Operator ';\|+\|-\|\*\|%\|\.\|>\|<\|=\|!\||\|&\|\~\|\^\|?\|:'
highlight Operator guifg=grey54 ctermfg=245
highlight Repeat guifg=#c678dd ctermfg=170
highlight StorageClass cterm=italic,bold
highlight Structure cterm=italic
highlight TypeDef cterm=italic
highlight Include guifg=#87ff87
highlight Exception guifg=#87ff87
highlight PreProc guifg=#87ff87
highlight PreCondit guifg=#87ff87
highlight QuickScopePrimary cterm=bold,underline
highlight QuickScopeSecondary cterm=italic,underline
highlight Pmenu guibg=#262626 ctermbg=235
highlight clear Search
highlight Search ctermbg=235 guibg=#004030
highlight clear Visual
highlight Visual cterm=reverse
highlight VertSplit cterm=NONE guifg=lightgreen
highlight cError guibg=#400000
highlight CocWarningHighlight cterm=undercurl guisp=orange
highlight CocErrorHighlight cterm=undercurl guisp=red
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
autocmd FileType vim map <F4> :w<CR>:source $MYVIMRC<CR>

"%% in command mode expands to the directory path of the current file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
cnoremap %. <C-R>=fnameescape(expand('%:r')).'.'<cr>
"Copy to the end of line
map Y y$
map H ^
map L $
"A good compromise between ^] and g]
map g] g
"A custom motion for top-level blocks with headers
"xnoremap <silent>af [[%o[[-
"onoremap <silent>af :<C-u>exec'normal v' . v:count1 . 'af'<CR>
"Always show at least 5 lines above/below the cursor
set scrolloff=3
"Cleaned up NPC-viewer. Run `:set list` to see
set listchars=tab:\|->,trail:_,extends:>,precedes:<,nbsp:+
"Erase the existant search highlighting, turn off visible whitespace and redraw the screen
map <Leader>r :nohlsearch<CR>:set nolist<CR>:redraw!<CR>

"Use relative line numbers only in normal mode
augroup every
autocmd!
    au InsertEnter * set norelativenumber
    au InsertLeave * set relativenumber
augroup END

"More sensible back-and-forth between panes
map <C-w><Tab> <C-w>p
"Quickly switch to last buffer in normal mode
nmap <Tab> <C-6>

nmap Q :update<CR>

"TODO sporak
nnoremap , ;
nnoremap ; ,
nnoremap g> g]

"Jump to last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

autocmd FileType cpp set keywordprg=cppman

"Open URLs with gx
let g:netrw_browsex_viewer="vivaldi-stable"

"Terminal support for undercurls
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

let c_space_errors = 1
let ruby_operators = 1
let ruby_space_errors = 1
let python_space_error_highlight = 1
