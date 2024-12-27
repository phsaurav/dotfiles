" Wrap lines in more readable
map Q gq

" Trigger Normal Mode
imap kj <Esc>

" Prevent Mouse from effecting vim
set mouse -=a

" Add last character in selection
set selection=inclusive

" Visual mode tab add indents
vmap <Tab> >gv
vmap <S-Tab> <gv
vnoremap <BS> d

" Remove any existing keybinding for space
nnoremap <SPACE> <Nop>

" Leader key
let mapleader = " "

" Use same clipboard
set clipboard+=unnamedplus
vnoremap <C-c> "+y     " Copy to clipboard with Ctrl+C
nnoremap <C-v> "+gP    " Paste from clipboard with Ctrl+V

" Clear search highlight
nnoremap <leader>d :nohl<CR>

" Delete without yanking
nnoremap d "_d
nnoremap D "_D
nnoremap dd "_dd

" Search for empty lines
nnoremap <leader>n /^$/<CR>:nohl<CR>

" Close active window
nnoremap <leader>c :q<CR>

" Split window
nnoremap <leader>s :vsplit<CR>

" Go to start of line
nnoremap gh _

" Go to end of line
nnoremap gl $

" Move to matching parenthesis
nnoremap g; %
vnoremap g; %

" Navigate to previous position in jump list
nnoremap go <C-o>

" Navigate to next position in jump list
nnoremap gi <C-i>
"
" Move to the right split with 'g-j'
nnoremap gl <C-w>l
nnoremap gj <C-w>j

" Move to the left split with 'g-k'
nnoremap gh <C-w>h
nnoremap gk <C-w>k

" Scroll 25% up
nnoremap L 16kzz

" Scroll 25% down
nnoremap H 16jzz


nnoremap <Space> :action LeaderAction<cr>
xnoremap <leader>b xi()<Esc>P
xnoremap <leader>{ c{}<Esc>P
xnoremap <leader>[ c[]<Esc>P
xnoremap <leader>' c''<Esc>P
vnoremap <leader>" xi""<Esc>P
nnoremap <S-Left> :action EditorLeftWithSelection<CR>
nnoremap <S-Right> :action EditorRightWithSelection<CR>
nnoremap <S-Up> :action EditorUpWithSelection<CR>
nnoremap <S-Down> :action EditorDownWithSelection<CR>

inoremap <S-Left> <C-O>:action EditorLeftWithSelection<CR>
inoremap <S-Right> <C-O>:action EditorRightWithSelection<CR>
inoremap <S-Up> <C-O>:action EditorUpWithSelection<CR>
inoremap <S-Down> <C-O>:action EditorDownWithSelection<CR>

" Substitute:
"   [w]ord under cursor
nnoremap gsw :%s/\<<C-r><C-w>\>//g<Left><Left>

" Visual Mode Substitution
xnoremap gsw y:%s/<C-r>"//g<Left><Left>

