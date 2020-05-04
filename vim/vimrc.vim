if exists('g:vscode')
  call plug#begin('~/.local/share/nvim/plugged')
  "######################################
  "########## Plugin bindings ###########
  xmap gc  <Plug>VSCodeCommentary
  nmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine

  nmap s <Plug>(easymotion-s2)

  "######################################
  "########## VSCode plugins ############
  Plug 'asvetliakov/vim-easymotion', {'as': 'vscode-motion'}
  Plug 'christoomey/vim-sort-motion'
  Plug 'cometsong/commentframe.vim'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'yggdroot/indentline'


  call plug#end()
else
  call plug#begin('~/.local/share/nvim/plugged')
  "######################################
  "########## Config section ############

  set t_Co=256
  set laststatus=2
  set number relativenumber
  set cursorline
  set encoding=UTF-8
  set softtabstop=2
  set shiftwidth=2
  set expandtab
  set splitbelow
  set splitright
  set termguicolors
  set shell=/usr/bin/zsh
  let g:airline_powerline_fonts = 1
  let g:indentLine_color_term = 239
  syntax on

  augroup AutoSaveFolds
    autocmd!
    autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
    autocmd BufWinEnter ?* silent! loadview
  augroup end

  "######################################
  "########## Plugin bindings ###########

  imap <c-x><c-k> <plug>(fzf-complete-word)
  imap <c-x><c-f> <plug>(fzf-complete-path)
  imap <c-x><c-l> <plug>(fzf-complete-buffer-line)

  nmap s <Plug>(easymotion-s2)

  nnoremap <leader>s :ToggleWorkspace<CR>
  nnoremap <silent> <leader>o :FZF<CR>
  " nnoremap <silent> <leader>h :History<CR>
  nnoremap <tab> <c-w>
  nnoremap <tab><tab> <c-w><c-w>
  noremap <Leader>y "*y
  noremap <Leader>p "*p
  noremap <Leader>Y "+y
  noremap <Leader>P "+p
  nmap ; :Buffers<CR>
  nmap <F8> :TagbarToggle<CR>
  nmap ga <Plug>(EasyAlign)
  map <C-n> :NERDTreeToggle<CR>

  "########### Plugin config ############

  let g:tagbar_autofocus = 1
  let g:tagbar_autoclose = 1
  let g:workspace_session_directory = $HOME.'/.local/share/nvim/sessions/'
  let g:workspace_session_disable_on_args = 1
  let g:workspace_autosave_always = 1
  let g:floaterm_keymap_new  = '<leader>t'
  " let g:floaterm_keymap_toggle = '<leader><tab>'
  " let g:floaterm_keymap_prev   = '<leader>tp'
  " let g:floaterm_keymap_next   = '<leader>tn'
  let g:floaterm_position = "center"
  let g:floaterm_winblend = 12
  let g:coc_global_extensions = ['coc-python', 'coc-snippets',  'coc-ultisnips', 'coc-json', 'coc-cmake']

  "######################################
  "########## Plugin section ############

  Plug 'KabbAmine/vCoolor.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'christoomey/vim-sort-motion'
  Plug 'cometsong/commentframe.vim'
  Plug 'honza/vim-snippets'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'lambdalisue/suda.vim'
  Plug 'majutsushi/tagbar'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'octol/vim-cpp-enhanced-highlight'
  Plug 'raimondi/delimitmate'
  Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
  Plug 'ryanoasis/vim-devicons'
  Plug 'scrooloose/nerdtree'
  Plug 'sheerun/vim-polyglot'
  Plug 'thaerkh/vim-workspace'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-sleuth'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'voldikss/vim-floaterm'
  Plug 'yggdroot/indentline'
  Plug 'easymotion/vim-easymotion'

  "######################################
  "############### Colors ###############

  Plug 'NLKNguyen/papercolor-theme'
  let g:PaperColor_Theme_Options = {
    \   'theme': {
    \     'default': {
    \       'transparent_background': 1
    \     }
    \   }
    \ }

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme='deus'

  " let g:gitgutter_set_sign_backgrounds = 1
  highlight SignColumn guibg=none

  "######################################

  call plug#end()
  colorscheme PaperColor
  highlight clear SignColumn
  call plug#end()
endif
