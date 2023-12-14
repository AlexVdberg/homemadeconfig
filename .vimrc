" Colorscheme setup
" You might have to force true color when using regular vim inside tmux as the
" colorscheme can appear to be grayscale with "termguicolors" option enabled.
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set termguicolors
"colorscheme yourfavcolorscheme

" tab character settings
set tabstop=4 softtabstop=0 shiftwidth=4 smarttab
"expand tabs into spaces
set expandtab

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
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" show statusline always
set laststatus=2
" show line and column numbers
set ruler

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

" exclude build folder from searches with wildignore
"set wildignore+=*/build/*

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
nnoremap <leader>s :call StripTrailingWhitespace()<cr>
nnoremap <leader>r :source ~/.vimrc<cr>

" markdown
" Set web link
let g:netrw_http_cmd='firefox'
" textwidth for markdown files. use gq to auto format
au BufRead,BufNewFile *.md setlocal textwidth=80

autocmd Filetype markdown setlocal spell
"au BufRead,BufNewFile *.md setlocal tagfunc=MarkdownTagFunc
"autocmd Filetype markdown setlocal tagfunc=MarkdownTagFunc

" Zettle Note Taking
let g:zettelkasten = "~/Documents/notes/"

command! ZettleIndex :execute ":e " fnameescape(zettelkasten) . "0.md" | :execute ":tcd " . fnameescape(zettelkasten)
nnoremap <leader>ni :ZettleIndex<CR>
command! -nargs=1 ZettleNew :execute ":e" zettelkasten . strftime("%Y%m%d%H%M") . "-<args>.md"
nnoremap <leader>nn :ZettleNew 

" copy file name into clipboard
nmap <leader>cs :let @+ = expand("%:t")<CR>
nmap <leader>cl :let @+ = expand("%")<CR> 

" set backspace type (backspace around line wraps)
set backspace=2



"""""""""""""""""""""
" Plugins
"""""""""""""""""""""
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
Plug 'sainnhe/sonokai'
Plug 'vim-pandoc/vim-pandoc-syntax', {'on': []}
Plug 'alepez/vim-gtest'
Plug 'ilyachur/cmake4vim'
Plug '~/dev/vim_z'
Plug 'christoomey/vim-tmux-navigator'
"Plug 'preservim/vim-markdown'

" Initialize plugin system
call plug#end()

"""""""""""""""""""""
" vim-pandoc-syntax
"""""""""""""""""""""
"augroup pandoc_syntax
"    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
"augroup END
"let g:pandoc#syntax#conceal#urls = 1
"set conceallevel=2
" only show concealed text in edit mode
"set concealcursor=nc

"""""""""""""""""""""
" Sonokai
"""""""""""""""""""""
" The configuration options should be placed before `colorscheme sonokai`.
let g:sonokai_style = 'default'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 1
colorscheme sonokai

"""""""""""""""""""""
" COC coc
"""""""""""""""""""""
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" : "\<TAB>"

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)

" Install coc extensions automatically
"let g:coc_global_extensions=['coc-clangd']

" COC doesnt like older versions of vim
"let g:coc_disable_startup_warning = 1

" enable using vim tagfunc through coc.nvim
set tagfunc=CocTagFunc

"""""""""""""""""""""
" fzf
"""""""""""""""""""""
nnoremap  <C-p> :GFiles<CR>
nnoremap <leader>p :Files<CR>
"nnoremap <leader>r :Rg <CR>

"""""""""""""""""""""
" vim-gtest
"""""""""""""""""""""
let g:gtest#gtest_command = "cmake-build-Release/test/test"
nnoremap <leader>g :GTestRun<cr>

"""""""""""""""""""""
" cmake4vim
"""""""""""""""""""""
let g:cmake_build_dir = "build"
nnoremap <leader>m :CMakeBuild<cr>
nnoremap <leader>n :CMake<cr>


"""""""""""""""""""""
" vim-tmux-navigator
"""""""""""""""""""""
let g:tmux_navigator_no_mappings = 1

"noremap <silent> <A-h> :<C-U>TmuxNavigateLeft<cr>
"noremap <silent> <A-j> :<C-U>TmuxNavigateDown<cr>
"noremap <silent> <A-k> :<C-U>TmuxNavigateUp<cr>
"noremap <silent> <A-l> :<C-U>TmuxNavigateRight<cr>
"noremap <silent> <A-;> :<C-U>TmuxNavigatePrevious<cr>
nnoremap <leader> k :echo 'hello'<cr>
nnoremap <M-j> :echo 'hello'<cr>
nnoremap <A-k> :wincmd k<CR>
