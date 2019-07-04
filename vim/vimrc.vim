set shell=/bin/zsh
call plug#begin('~/.local/share/nvim/plugged')

"########## Config section ############

set t_Co=256
set relativenumber
set cursorline
set encoding=UTF-8
" set termguicolors 
let g:airline_powerline_fonts = 1
let g:indentLine_color_term = 239
syntax on

augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup end

"######################################
"########## Plugin section ############
"
Plug 'valloric/youcompleteme', {'do': 'python3 ./install.py'}

Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>

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
nmap <F8> :TagbarToggle<CR>

Plug 'ryanoasis/vim-devicons'

"######################################
"############### Colors ###############
"
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
