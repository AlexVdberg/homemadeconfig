" tab character settings
set tabstop=4 softtabstop=0 shiftwidth=4 smarttab
"set expandtab

" Enable syntax highlighting
syntax on

" Mouse support
if has("mouse_sgr")
	set ttymouse=sgr
else
	set ttymouse=xterm2
end
set mouse=a

" show line numbers
set nu

" show statusline always
set laststatus=2

" search preferences
set incsearch
set hlsearch
" hide highlighted search results
map <silent> <leader>h :noh<CR>

if has("clipboard")
	" change the default register to use the CLIPBOARD buffer in X
	" Requires vim to be complied with +clipboard. I used gvim
	set clipboard=unnamedplus
end

" Functions
function! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction

" Shortcuts
nnoremap <leader>m :make<cr>
nnoremap <leader>s :call StripTrailingWhitespace()<cr>
nnoremap <leader>r :source ~/.vimrc<cr>

" Plugins
" Install vim-plug automatically
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Initialize plugin system
call plug#end()


"""""""""""""""""""""
" COC
"""""""""""""""""""""
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)

" Install coc extensions automatically
"let g:coc_global_extensions=['coc-clangd']
" COC doesnt like older versions of vim
"let g:coc_disable_startup_warning = 1

"""""""""""""""""""""
" FZF
"""""""""""""""""""""
nnoremap  <C-p> :GFiles<CR>
