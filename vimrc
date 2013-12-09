" Appearance 
set background=dark
colorscheme solarized
set guifont=Monospace\ bold\ 11
" Tabs width
set tabstop=4
" Replace tabs with spaces
set shiftwidth=4
set expandtab
filetype plugin indent on
syntax on
set number
set autoindent
set incsearch
"set hlsearch
set ignorecase " set smartcase for searching in a case sensitive way
set wildmenu " better file selection
set showmatch " show matching brackets
" Get more real estate
set guioptions-=m " remove menu bar
set guioptions-=T " remove toolbar
" Pathogen for loading plugins
call pathogen#infect()
"define leader character (for nerd commenter, mostly)
let mapleader = ","
" Save on lost focus
"au FocusLost * :wa
" Highlight current line and column
"set cursorline! cursorcolumn!
" Current directory is always the directory of the current file
set autochdir
" ,aa Quick command for autoindenting what we just pasted
map ,aa V`]=

"""""" Copy-paste
" Paste with ctrl-v in insert mode
inoremap <C-v> <Esc>"*pa
" Paste yanked text even after deleting text (yanked text is still in registry
" "0)
nmap <C-v> "0P

"""""" Moving around
" Delete previous word on ctrl-backspace
imap <C-BS> <C-W>
" Use tab to match brackets/parenthesis
nnoremap <tab> %
vnoremap <tab> %
" Get rid of help key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

"""""" Various deactivated plugins
" Toggle nerd tree with F2
" o -> open
" i -> horizontal split
" s -> vertical split
" t -> tab
" p -> got o parent directory
" r -> refresh
"map <F2> :NERDTreeToggle<CR>
 
" Latex suite
"let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
"let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'
"let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'
"let g:Tex_CompileRule_pdf = 'ps2pdf $*.ps'

" Ack-grep
" https://github.com/mileszs/ack.vim
"let g:ackprg="ack-grep -H --nocolor --nogroup --column"

" Redirect output of make command to vim's quickfix (use :Make)
"command -nargs=* Make write | make <args> | cwindow 6
"" use shift-F2 to run the last :Make command and to view the errors in a
"" quickfix window (insanely useful)
"map <S-F2> :wa<cr>:Make <Up><CR>

"""""""" Tabs
" Change tab easily
imap <C-Tab> <Esc>:tabn<CR>i
imap <C-S-Tab> <Esc>:tabp<CR>i
imap <C-A-T> <Esc>:tabnew<CR>i
map <C-Tab> :tabn<CR>
map <C-S-Tab> :tabp<CR>
map <C-A-T> :tabnew<CR>
map <S-F4> :tabnew<CR>
nnoremap <silent> <C-S-PageUp> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <C-S-PageDown> :execute 'silent! tabmove ' . tabpagenr()<CR>
" Type :Tn instead of :tabnew
cnoreabbrev Tn tabnew
" Set appropriate tab names
function! GuiTabLabel()
    " add the tab number
    let label = '['.tabpagenr()

    " modified since the last save?
    let buflist = tabpagebuflist(v:lnum)
    for bufnr in buflist
        if getbufvar(bufnr, '&modified')
                let label .= '*'
                break
        endif
    endfor

    " count number of open windows in the tab
    let wincount = tabpagewinnr(v:lnum, '$')
    if wincount > 1
        let label .= ', '.wincount
    endif
    let label .= '] '

    " add the file name without path information
    let n = bufname(buflist[tabpagewinnr(v:lnum) - 1])
    let label .= fnamemodify(n, ':t')

    return label
endfunction
set guitablabel=%{GuiTabLabel()}

""""""""""" Fuzzy file finder CtrlP
let g:ctrlp_working_path_mode = 'ra'
"set wildignore+=*/env/*,*.pyc,*.mp3,*.ogg,*/static/audio/
"let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.?)(git|hg|svn|static\/audio|env|build)$',
  \ 'file': '\v\.(exe|so|dll|pyc|o)$',
  \ }

""""""""""""""""""""""""""""""""""""""
"""""""""""" Autompletion """"""""""""
""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""" 
" Supertab: autocomplete on tab
"""""""""""""""""""""""""""""""" 
" context: finds libraries/local variables depending on context
let g:SuperTabDefaultCompletionType="context"
" menu: display popup menu
" menuone: display popup menu even when there is just one corresponding entry
" preview: display documentation
" longest: autocomplete only typed characters
set completeopt=menu,menuone,preview,longest 
"" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"" Hide omnicomplete preview window after method was selected
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"""""""""""""""""""""""""" PythonMode
" Motion is useful, e.g: ]] and [[ to go to previous/next class
"let g:pymode_rope = 0 " disable almost everything 
"let g:pymode_doc = 0  " disable documentation feature
let g:pymode_indent = 0
let g:pymode_folding = 0
let g:pymode_options = 0 " 1 => no code wrap
let g:pymode_lint_checker = "pyflakes"
"let g:pymode_lint_ignore = "W0401" " ignore import * errors

"""""""""""""""""" Syntastic: great for static analysis
"Activate this to see syntax errors by default
let g:syntastic_always_populate_loc_list=1
" Launch :Errors in order to view the error list at any point
" Disable in python (python-mode does the job)
let g:syntastic_mode_map = { 'mode': 'active',
                               \ 'active_filetypes': [],
                               \ 'passive_filetypes': ['python'] }

"""""""""""""""""""""""""" C++ (ctags)
set tags=tags,./tags;/
"" configure tags - add additional tags here or comment out not-used ones
" Great explanations of how to use ctags in vim:
" http://blog.stwrt.ca/2012/10/31/vim-ctags
" http://vim.wikia.com/wiki/Browsing_programs_with_tags
set tags+=/home/regis/.vim/tags/**/tags
" build tags of your own project with ,t
" Move to closest git repository and compute python and c++ tags
:map ,t :! while [ 1 ]; do if [ -d '.git' ]; then break; fi; cd ..; done; name="$(basename $(pwd))"; mkdir -p ~/.vim/tags/${name}; ctags -R --c++-kinds=+p --fields=+iS --languages=c,c++,python -f ~/.vim/tags/${name}/tags $(pwd)/*<CR>

"" OmniCppComplete
let OmniCpp_NamespaceSearch = 2 " 2: search in included files
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1 " show/hide private-/protected#/public+
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 0 " autocomplete after .
let OmniCpp_MayCompleteArrow = 0 " autocomplete after ->
let OmniCpp_MayCompleteScope = 0 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
let OmniCpp_DisplayMode = 1 " display private member
let OmniCpp_ShowScopeInAbbr = 1 " Scope indicated as abbreviation prefix
let OmniCpp_ShowPrototypeInAbbr = 1 " Show function prototype in abbreviation

"Switch between header/source file
:map <F4> :vsplit %:p:s,.hpp$,.X123X,:s,include,X456X,:s,.cpp$,.hpp,:s,src,include,:s,.X123X$,.cpp,:s,X456X,src,<CR>

" Deactivate folds
set nofoldenable
set foldmethod=manual
"setlocal foldmethod=syntax " or is it indent?
