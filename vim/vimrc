set nocompatible              " be iMproved, required
filetype off                  " required

set t_Co=256
set mouse=a
set ttymouse=sgr
syntax on
colorscheme mustang
set number
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent

set hlsearch
set ignorecase
set incsearch
set ruler
nnoremap <CR> :noh<CR><CR>

highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 80)

map <C-K> :pyf /home/glalonde/.vim/clang-format.py<cr>
imap <C-K> <c-o>:pyf /home/glalonde/.vim/clang-format.py<cr>
