" Vim file type plug-in
" Author: Peter Odding <peter@peterodding.com>
" Last Change: December 1, 2011
" URL: http://peterodding.com/code/vim/notes/

if exists('b:did_ftplugin')
  finish
else
  let b:did_ftplugin = 1
endif


" Copy indent from previous line. {{{1
setlocal autoindent
if &ft != 'notes' | let b:undo_ftplugin = 'set autoindent<' | endif

" Set &tabstop and &shiftwidth options for bulleted lists. {{{1
setlocal tabstop=3 shiftwidth=3 expandtab
if &ft != 'notes' | let b:undo_ftplugin .= ' | set tabstop< shiftwidth< expandtab<' | endif

" Automatic formatting for bulleted lists. {{{1
let &l:comments = xolox#notes#get_comments_option()
setlocal formatoptions=tcron
if &ft != 'notes' | let b:undo_ftplugin .= ' | set comments< formatoptions<' | endif

" Automatic text folding based on headings. {{{1
setlocal foldmethod=expr
setlocal foldexpr=xolox#notes#foldexpr()
setlocal foldtext=xolox#notes#foldtext()
if &ft != 'notes' | let b:undo_ftplugin .= ' | set foldmethod< foldexpr< foldtext<' | endif

" Enable concealing of notes syntax markers? {{{1
if has('conceal')
  setlocal conceallevel=3
if &ft != 'notes' |   let b:undo_ftplugin .= ' | set conceallevel<' | endif
endif

" Change <cfile> to jump to notes by name. {{{1
setlocal includeexpr=xolox#notes#include_expr(v:fname)
if &ft != 'notes' | let b:undo_ftplugin .= ' | set includeexpr<' | endif

" Enable completion of note titles using C-x C-u. {{{1
setlocal completefunc=xolox#notes#user_complete
if &ft != 'notes' | let b:undo_ftplugin .= ' | set completefunc<' | endif

" Enable completion of tag names using C-x C-o. {{{1
setlocal omnifunc=xolox#notes#omni_complete
if &ft != 'notes' | let b:undo_ftplugin .= ' | set omnifunc<' | endif

" Automatic completion of tag names after typing "@". {{{1

inoremap <buffer> <silent> @ @<C-x><C-o>
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "iunmap <buffer> @"' | endif

" Automatic completion of tag names should not interrupt the flow of typing,
" for this we have to change the (unfortunately) global option &completeopt.
set completeopt+=longest

" Change double-dash to em-dash as it is typed. {{{1
if g:notes_smart_quotes && xolox#notes#unicode_enabled()
  imap <buffer> -- —
if &ft != 'notes' |   let b:undo_ftplugin .= ' | execute "iunmap <buffer> --"' | endif
endif

" Change plain quotes to curly quotes as they're typed. {{{1
if g:notes_smart_quotes
  imap <buffer> <expr> ' xolox#notes#insert_quote(1)
  imap <buffer> <expr> " xolox#notes#insert_quote(2)
if &ft != 'notes' |   let b:undo_ftplugin .= ' | execute "iunmap <buffer> ''"' | endif
if &ft != 'notes' |   let b:undo_ftplugin .= ' | execute ''iunmap <buffer> "''' | endif
endif

" Change ASCII style arrows to Unicode arrows. {{{1
if g:notes_smart_quotes && xolox#notes#unicode_enabled()
  imap <buffer> -> →
  imap <buffer> <- ←
if &ft != 'notes' |   let b:undo_ftplugin .= ' | execute "iunmap <buffer> ->"' | endif
if &ft != 'notes' |   let b:undo_ftplugin .= ' | execute "iunmap <buffer> <-"' | endif
endif

" Convert ASCII list bullets to Unicode bullets. {{{1
if g:notes_smart_quotes
  imap <buffer> <expr> * xolox#notes#insert_bullet('*')
  imap <buffer> <expr> - xolox#notes#insert_bullet('-')
  imap <buffer> <expr> + xolox#notes#insert_bullet('+')
if &ft != 'notes' |   let b:undo_ftplugin .= ' | execute "iunmap <buffer> *"' | endif
if &ft != 'notes' |   let b:undo_ftplugin .= ' | execute "iunmap <buffer> -"' | endif
if &ft != 'notes' |   let b:undo_ftplugin .= ' | execute "iunmap <buffer> +"' | endif
endif

" Format three asterisks as a horizontal ruler. {{{1
inoremap <buffer> *** <C-o>:call xolox#notes#insert_ruler()<CR>
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "iunmap <buffer> ***"' | endif

" Indent list items using <Tab> and <Shift-Tab>. {{{1
imap <buffer> <silent> <Tab> <C-o>:call xolox#notes#indent_list(1, line('.'), line('.'))<CR>
smap <buffer> <silent> <Tab> <C-o>:<C-u>call xolox#notes#indent_list(1, line("'<"), line("'>"))<CR><C-o>gv
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "iunmap <buffer> <Tab>"' | endif
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "sunmap <buffer> <Tab>"' | endif
imap <buffer> <silent> <S-Tab> <C-o>:call xolox#notes#indent_list(-1, line('.'), line('.'))<CR>
smap <buffer> <silent> <S-Tab> <C-o>:<C-u>call xolox#notes#indent_list(-1, line("'<"), line("'>"))<CR><C-o>gv
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "iunmap <buffer> <S-Tab>"' | endif
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "sunmap <buffer> <S-Tab>"' | endif

" Indent list items using <Alt-Left> and <Alt-Right>. {{{1
imap <buffer> <silent> <A-Right> <C-o>:call xolox#notes#indent_list(1, line('.'), line('.'))<CR>
smap <buffer> <silent> <A-Right> <C-o>:<C-u>call xolox#notes#indent_list(1, line("'<"), line("'>"))<CR><C-o>gv
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "iunmap <buffer> <A-Right>"' | endif
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "sunmap <buffer> <A-Right>"' | endif
imap <buffer> <silent> <A-Left> <C-o>:call xolox#notes#indent_list(-1, line('.'), line('.'))<CR>
smap <buffer> <silent> <A-Left> <C-o>:<C-u>call xolox#notes#indent_list(-1, line("'<"), line("'>"))<CR><C-o>gv
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "iunmap <buffer> <A-Left>"' | endif
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "sunmap <buffer> <A-Left>"' | endif

" Automatically remove empty list items on Enter. {{{1
inoremap <buffer> <silent> <expr> <CR> xolox#notes#cleanup_list()
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "iunmap <buffer> <CR>"' | endif

" Shortcuts to create new notes from the selected text. {{{1

vmap <buffer> <silent> <Leader>en :NoteFromSelectedText<CR>
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "vunmap <buffer> <Leader>en"' | endif

vmap <buffer> <silent> <Leader>sn :SplitNoteFromSelectedText<CR>
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "vunmap <buffer> <Leader>sn"' | endif

vmap <buffer> <silent> <Leader>tn :TabNoteFromSelectedText<CR>
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "vunmap <buffer> <Leader>tn"' | endif

" }}}1

" keyword for context. {{{1
setlocal iskeyword+=@-@
if &ft != 'notes' | let b:undo_ftplugin .= ' | set iskeyword<' | endif


" tasknotes default key mappings . {{{1
nmap <buffer> <silent> <Leader>td <Plug>tasknotes_toggle_done
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "nunmap <buffer> <Leader>td"' | endif

nmap <buffer> <silent> <Leader>tx <Plug>tasknotes_toggle_cancelled
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "nunmap <buffer> <Leader>tx"' | endif

nmap <buffer> <silent> <Leader>tc <Plug>tasknotes_show_context
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "nunmap <buffer> <Leader>tc"' | endif

nmap <buffer> <silent> <Leader>ta <Plug>tasknotes_show_all
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "nunmap <buffer> <Leader>ta"' | endif

nmap <buffer> <silent> <Leader>tp <Plug>tasknotes_fold_all_projects
if &ft != 'notes' | let b:undo_ftplugin .= ' | execute "nunmap <buffer> <Leader>tp"' | endif
" }}}1

" This is currently the only place where a command is guaranteed to be
" executed when the user edits a note. Maybe I shouldn't abuse this (it
" doesn't feel right ;-) but for now it will do.
call xolox#notes#check_sync_title()

" vim: ts=2 sw=2 et
