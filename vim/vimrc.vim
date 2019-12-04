set shell=/usr/bin/zsh
call plug#begin('~/.local/share/nvim/plugged')

"########## Config section ############

set t_Co=256
set number relativenumber
set cursorline
set encoding=UTF-8
set softtabstop=2
set shiftwidth=2
set expandtab
set splitbelow
set splitright
set termguicolors
let g:airline_powerline_fonts = 1
let g:indentLine_color_term = 239
syntax on

augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup end

"########## Plugin bindings ###########

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-buffer-line)

nnoremap <leader>s :ToggleWorkspace<CR>
nnoremap <silent> <leader>o :FZF<CR>
" nnoremap <silent> <leader>h :History<CR>
nnoremap <tab> <c-w>
nnoremap <tab><tab> <c-w><c-w>
nmap ; :Buffers<CR>
nmap <F8> :TagbarToggle<CR>
nmap ga <Plug>(EasyAlign)
map <C-n> :NERDTreeToggle<CR>

"########### Plugin config ############

let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:workspace_session_directory = $HOME.'/.local/share/nvim/sessions/'
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/.local/share/nvim/snippets"]
let g:floaterm_keymap_new  = '<leader>t'
" let g:floaterm_keymap_toggle = '<leader><tab>'
" let g:floaterm_keymap_prev   = '<leader>tp'
" let g:floaterm_keymap_next   = '<leader>tn'
let g:floaterm_position = "center"
let g:floaterm_winblend = 12

"######################################
"########## Plugin section ############

Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'voldikss/vim-floaterm'

"######################################
"############### Colors ###############

" Plug 'mhartington/oceanic-next' 
" Plug 'aonemd/kuroi.vim'
Plug 'BarretRen/vim-colorscheme'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='deus'

"######################################

call plug#end()
colorscheme PaperColor
" colorscheme kuroi
