" Vim syntax file
" Language:	tasknotes (http://hogbaysoftware.com/projects/tasknotes)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		https://github.com/davidoc/tasknotes.vim
" Last Change:  2011-02-15

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if version < 508
  command! -nargs=+ HiLink hi link <args>
else
  command! -nargs=+ HiLink hi def link <args>
endif

" syn case ignore

syn region tasknotesProject matchgroup=tasknotesProject start=/^\t*\%(\u[^:]\+\)/ end=/:\%(\s\+@\w\+\%((.*)\)\=\)\{-}$/ oneline contains=tasknotesContextText

syn region tasknotesProjectFold start=/\_^\t*\%(.\+:\)/ end=/\_^\s*\_$/ transparent fold

syn region tasknotesContextText start=/\s\+@/ end=/\%(\w\+\%((.*)\)\=\)\_s/ transparent oneline contained containedin=tasknotesProject,tasknotesTask contains=tasknotesContext,tasknotesContextProperty
syn region tasknotesContext matchgroup=tasknotesDelimiter start=/@\%(\w\+\)\@=/ end=/\%(\_s\|(\)\@=/  contained oneline containedin=tasknotesContextText
syn region tasknotesContextProperty matchgroup=tasknotesDelimiter start="(" end=")" contained containedin=tasknotesContextText

syn region tasknotesTask matchgroup=tasknotesTaskDelimiter start=/^\%(\t\+\)[-+]\%(\s\+\)/ end=/\s*$/ oneline keepend contains=tasknotesDone,tasknotesCancelled,tasknotesContextText
syn match tasknotesDone /\w.*\%(@[Dd]one\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask conceal cchar=⚡ contains=tasknotesContextText
syn match tasknotesCancelled /\w.*\%(@[Cc]ance[l]\{1,2}ed\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask conceal cchar=⌇ contains=tasknotesContextText


syn sync fromstart

HiLink tasknotesProject         Title
HiLink tasknotesContext         Underlined
HiLink tasknotesContextProperty Identifier
HiLink tasknotesTask            String
HiLink tasknotesTaskDelimiter   SpecialChar
HiLink tasknotesDone            Conceal
HiLink tasknotesCancelled       Ignore
HiLink tasknotesDelimiter       Delimiter

" syn match  tasknotesLineContinue ".$" contained
" syn match  tasknotesComment "^.*$"
" HiLink tasknotesComment         Normal



let b:current_syntax = "tasknotes"
delcommand HiLink
" vim: ts=8
