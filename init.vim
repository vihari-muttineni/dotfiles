let mapleader = ' '
let maplocalleader = ' '

nnoremap <silent> <Leader>vev :e ~/.config/nvim/init.vim<CR>
inoremap <C-\> <ESC>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>
noremap <Leader>y "*y

nnoremap 0 ^

set hidden
set backspace=indent,eol,start
set expandtab
set shiftwidth=4
set softtabstop=4
set scrolloff=99
set wrap
set linebreak
set breakindent
set showbreak='..'

set incsearch
set nohlsearch
set ignorecase
set smartcase
set gdefault
set noswapfile

set number


command! -bang WQ wq<bang>
command! -bang Wq wq<bang>
command! -bang Wqa wqa<bang>
command! -bang W w<bang>
command! -bang Q q<bang>


call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'sainnhe/everforest'
Plug 'sheerun/vim-polyglot'

Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'neovim/nvim-lspconfig'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-endwise'
Plug 'mhinz/vim-grepper'
Plug 'romainl/vim-qf'
call plug#end()

nnoremap <Leader>f :Files<CR>
nnoremap <Leader>b :Buffer<CR>
nnoremap <Leader>gh :GBrowse<CR>
vnoremap <Leader>gh :GBrowse<CR>
nmap <Leader>c gcc
vmap <Leader>c gcc<ESC>
nnoremap <Leader>d oimport pdb;pdb.set_trace()<ESC>
nmap <Leader>q ysiw"
nmap <Leader>rq ds"

" relative path  (src/foo.txt)
nnoremap <leader>cp :let @*=expand("%")<CR>

" filename       (foo.txt)
nnoremap <leader>cf :let @*=expand("%:t")<CR>

syntax on
" Important!!
if has('termguicolors')
  set termguicolors
endif
" For dark version.
set background=dark
let g:everforest_background = 'hard'
colorscheme everforest



" ----- mhinz/grepper ----- {{{
let g:grepper = {}
" Only use rg for grepping
let g:grepper.tools = ['rg']
" See ~/.vim/after for more grepper settings
" Highlight search matches (like it were hlsearch)
" let g:grepper.highlight = 1
" Don't use the quickfix list. In Neovim 0.4.2, this causes grepper to get
" into a weird state. Repro:
" vim -p foo bar
" :Grepper foo<CR>
" gr
" :Grepper foo<CR>
" Observe that the screen is now irrecoverably half height
" NOTE: This appears to have been fixed (probably in 0.5.0+?) but loclist is
" still preferrable.
let g:grepper.quickfix = 0
" Defalt to searching the entire repo; otherwise, search 'filecwd' (see help)
" let g:grepper.dir = 'repo,filecwd'
let g:grepper.dir = 'filecwd'

" Launch grepper with operator support
nmap s <plug>(GrepperOperator)
xmap s <plug>(GrepperOperator)

nnoremap <leader>a :Grepper<CR>
nnoremap <leader>* :Grepper -cword -noprompt<CR>

hi link GrepperQuery Normal


lua << EOF
local nvim_lsp = require('lspconfig')
nvim_lsp.solargraph.setup{}
nvim_lsp.tsserver.setup{}
nvim_lsp.pylsp.setup{}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- buf_set_keymap('n', 'aaa', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<leader>t', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', 'rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', 'ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "tsserver", "solargraph", "pylsp" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
}
end
EOF

