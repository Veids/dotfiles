set shell=/bin/zsh
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"########## Config section ############

set t_Co=256
set relativenumber
let g:airline_powerline_fonts = 1
let g:indentLine_color_term = 239
syntax on
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>

augroup AutoSaveFolds
	autocmd!
	autocmd BufWinLeave * mkview
	autocmd BufWinEnter * silent loadview
augroup END

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
"Plugin 'octol/vim-cpp-enhanced-highlight'

"Plugin 'flazz/vim-colorschemes'
"Plugin 'dracula/vim'
Plugin 'mhartington/oceanic-next'

"######################################

call vundle#end()
colorscheme OceanicNext
filetype plugin indent on 
