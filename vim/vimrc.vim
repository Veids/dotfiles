set shell=/bin/zsh
call plug#begin('~/.local/share/nvim/plugged')

"########## Config section ############

set t_Co=256
set relativenumber
set cursorline
set encoding=UTF-8
set softtabstop=2
" set termguicolors 
let g:airline_powerline_fonts = 1
let g:indentLine_color_term = 239
syntax on

augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup end

"########## Plugin bindings ###########
"
nnoremap <leader>s :ToggleWorkspace<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>
nmap ; :Buffers<CR>
nmap <F8> :TagbarToggle<CR>
nmap ga <Plug>(EasyAlign)
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
xmap ga <Plug>(EasyAlign)
map <C-n> :NERDTreeToggle<CR>

"########### Plugin config ############

let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:workspace_session_directory = $HOME . '/.local/share/nvim/sessions/'
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:ale_python_mypy_auto_pipenv = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_linters = {
\   'python': ['mypy']
\}

"######################################
"########## Plugin section ############

Plug 'valloric/youcompleteme', {'do': 'python3 ./install.py'}
Plug 'scrooloose/nerdtree'
Plug 'yggdroot/indentline'
Plug 'chiel92/vim-autoformat'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'christoomey/vim-sort-motion'
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-fugitive'
Plug 'majutsushi/tagbar'
Plug 'ryanoasis/vim-devicons'
Plug 'thaerkh/vim-workspace'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/vim-easy-align'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'sheerun/vim-polyglot'
Plug 'w0rp/ale'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'terryma/vim-smooth-scroll'

"######################################
"############### Colors ###############

" Plug 'rafi/awesome-vim-colorschemes'
" Plug 'neutaaaaan/blaaark'
" Plug 'chase/focuspoint-vim'
" Plug 'aonemd/kuroi.vim'
Plug 'mhartington/oceanic-next' 
Plug 'BarretRen/vim-colorscheme'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='deus'

"######################################

call plug#end()
colorscheme monokai
