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

" Initialize plugin system
call plug#end()
