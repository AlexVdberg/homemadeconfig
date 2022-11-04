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
"set noexpandtab

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

" exclude build folder from searches with wildignore
set wildignore+=*/build/*

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

" Zettle Note Taking
let g:zettelkasten = "/home/MAGICLEAP/avandenberg/Documents/notes/"

"function! ZettelIndex()
"	:e zettelkasten . /index.md
"	:cd zettelkasten
"endfunction
"nnoremap <leader>ni :call ZettleIndex()<CR>

command! ZettleIndex :execute ":e " fnameescape(zettelkasten) . "index.md" | :execute ":tcd " . fnameescape(zettelkasten)
nnoremap <leader>ni :ZettleIndex<CR>
command! -nargs=1 ZettleNew :execute ":e" zettelkasten . strftime("%Y%m%d%H%M") . "-<args>.md"
nnoremap <leader>nn :ZettleNew 

" copy file name into clipboard
nmap <leader>cs :let @+ = expand("%:t")<CR>
nmap <leader>cl :let @+ = expand("%")<CR> 

" set backspace type
set backspace=2

"parameters:
"
" - step +1 for right, -1 for left
"
" TODO: multiple lines.
"
function! s:FindCornerOfSyntax(lnum, col, step)
    let l:col = a:col
    let l:syn = synIDattr(synID(a:lnum, l:col, 1), 'name')
    while synIDattr(synID(a:lnum, l:col, 1), 'name') ==# l:syn
        let l:col += a:step
    endwhile
    return l:col - a:step
endfunction

" Return the next position of the given syntax name,
" inclusive on the given position.
"
" TODO: multiple lines
"
function! s:FindNextSyntax(lnum, col, name)
    let l:col = a:col
    let l:step = 1
    while synIDattr(synID(a:lnum, l:col, 1), 'name') !=# a:name
        let l:col += l:step
    endwhile
    return [a:lnum, l:col]
endfunction

function! s:FindCornersOfSyntax(lnum, col)
    return [<sid>FindLeftOfSyntax(a:lnum, a:col), <sid>FindRightOfSyntax(a:lnum, a:col)]
endfunction

function! s:FindRightOfSyntax(lnum, col)
    return <sid>FindCornerOfSyntax(a:lnum, a:col, 1)
endfunction

function! s:FindLeftOfSyntax(lnum, col)
    return <sid>FindCornerOfSyntax(a:lnum, a:col, -1)
endfunction

" Returns:
"
" - a string with the the URL for the link under the cursor
" - an empty string if the cursor is not on a link
"
" TODO
"
" - multiline support
" - give an error if the separator does is not on a link
"
function! Markdown_GetUrlForPosition(lnum, col)
    let l:lnum = a:lnum
    let l:col = a:col
    let l:syn = synIDattr(synID(l:lnum, l:col, 1), 'name')
	"echomsg l:syn

    if l:syn ==# 'mkdInlineURL' || l:syn ==# 'mkdURL' || l:syn ==# 'mkdLinkDefTarget' || l:syn ==# 'pandocReferenceURL' || l:syn ==# 'markdownUrl'
        " Do nothing.
    elseif l:syn ==# 'markdownLinkText'
        let [l:lnum, l:col] = <sid>FindNextSyntax(l:lnum, l:col, 'markdownUrl')
        let l:syn = 'markdownUrl'
    elseif l:syn ==# 'markdownLinkTextDelimiter'
        let l:line = getline(l:lnum)
        let l:char = l:line[col - 1]
        if l:char ==# '<'
            let l:col += 1
        elseif l:char ==# '>' || l:char ==# ')'
            let l:col -= 1
        elseif l:char ==# '[' || l:char ==# ']' || l:char ==# '('
            let [l:lnum, l:col] = <sid>FindNextSyntax(l:lnum, l:col, 'markdownUrl')
        else
            return ''
        endif
    elseif l:syn ==# 'pandocReferenceLabel'
        let [l:lnum, l:col] = <sid>FindNextSyntax(l:lnum, l:col, 'pandocReferenceURL')
        let l:syn = 'pandocReferenceURL'
    elseif l:syn ==# 'pandocOperator'
        let l:line = getline(l:lnum)
        let l:char = l:line[col - 1]
        if l:char ==# '<'
            let l:col += 1
        elseif l:char ==# '>' || l:char ==# ')'
            let l:col -= 1
        elseif l:char ==# '[' || l:char ==# ']' || l:char ==# '('
            let [l:lnum, l:col] = <sid>FindNextSyntax(l:lnum, l:col, 'pandocReferenceURL')
        else
            return ''
        endif
    elseif l:syn ==# 'mkdLink'
        let [l:lnum, l:col] = <sid>FindNextSyntax(l:lnum, l:col, 'mkdURL')
        let l:syn = 'mkdURL'
    elseif l:syn ==# 'mkdDelimiter'
        let l:line = getline(l:lnum)
        let l:char = l:line[col - 1]
        if l:char ==# '<'
            let l:col += 1
        elseif l:char ==# '>' || l:char ==# ')'
            let l:col -= 1
        elseif l:char ==# '[' || l:char ==# ']' || l:char ==# '('
            let [l:lnum, l:col] = <sid>FindNextSyntax(l:lnum, l:col, 'mkdURL')
        else
            return ''
        endif
    else
        return ''
    endif

    let [l:left, l:right] = <sid>FindCornersOfSyntax(l:lnum, l:col)
    return getline(l:lnum)[l:left - 1 : l:right - 1]
endfunction

function! s:VersionAwareNetrwBrowseX(url)
    if has('patch-7.4.567')
        call netrw#BrowseX(a:url, 0)
    else
        call netrw#NetrwBrowseX(a:url, 0)
    endif
endf

" Front end for GetUrlForPosition.
"
function! OpenUrlUnderCursor()
    let l:url = Markdown_GetUrlForPosition(line('.'), col('.'))
	"echomsg l:url
    if l:url !=# ''
		execute "e " . l:url
"        echomsg s:VersionAwareNetrwBrowseX(l:url)
    else
        echomsg 'The cursor is not on a link.'
    endif
endfunction

nnoremap <leader>u :call OpenUrlUnderCursor()<CR>


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
" FZF
"""""""""""""""""""""
nnoremap  <C-p> :GFiles<CR>
nnoremap <leader>p :Files<CR>
nnoremap <leader>r :Rg <CR>

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
