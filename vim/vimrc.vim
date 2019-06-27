set shell=/bin/zsh
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"########## Config section ############

set t_Co=256
set relativenumber
set cursorline
" set termguicolors 
let g:airline_powerline_fonts = 1
let g:indentLine_color_term = 239
syntax on

augroup AutoSaveFolds
  autocmd!
  " view files are about 500 bytes
  " bufleave but not bufwinleave captures closing 2nd tab
  " nested is needed by bufwrite* (if triggered via other autocmd)
  autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup end

" set viewoptions=folds,cursor
" set sessionoptions=folds

"######################################

Plugin 'VundleVim/Vundle.vim'

"########## Plugin section ############

Plugin 'valloric/youcompleteme'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_theme='deus'

Plugin 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>

Plugin 'yggdroot/indentline'
Plugin 'chiel92/vim-autoformat'
Plugin 'octol/vim-cpp-enhanced-highlight'


"############### Colors ###############
Plugin 'mhartington/oceanic-next'
" Plugin 'rafi/awesome-vim-colorschemes'
" Plugin 'neutaaaaan/blaaark'
" Plugin 'chase/focuspoint-vim'
" Plugin 'aonemd/kuroi.vim'
Plugin 'BarretRen/vim-colorscheme'

Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'christoomey/vim-sort-motion'

"######################################

call vundle#end()
colorscheme monokai
filetype plugin indent on 
