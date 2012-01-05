" Vim syntax script
" Author: Peter Odding <peter@peterodding.com>
" Last Change: November 25, 2011
" URL: http://peterodding.com/code/vim/notes/

" Note: This file is encoded in UTF-8 including a byte order mark so
" that Vim loads the script using the right encoding transparently.

" Quit when a syntax file was already loaded.
if exists('b:current_syntax')
  finish
endif

runtime! syntax/markdown.vim
unlet! b:current_syntax

" Check for spelling errors in all text.
syntax spell toplevel

" Inline elements.                                                        {{{1

" Cluster of elements which never contain a newline character.
syntax cluster notesInline contains=notesName

" Default highlighting style for notes syntax markers.
highlight def link notesHiddenMarker Ignore

" Highlight note names as hyperlinks.                                     {{{2
call xolox#notes#highlight_names(1)
syntax cluster notesInline add=notesName
highlight def link notesName Underlined

" Highlight @tags as hyperlinks.                                          {{{2
syntax match notesTagName /\(^\|\s\)\@<=@\k\+/
highlight def link notesTagName Underlined

" Highlight Numbered list                                                 {{{2
syntax match notesListNumber /^\s*\zs\d\+[[:punct:]]\?\ze\s/
highlight def link notesListNumber Comment

" Highlight quoted fragments.                                             {{{2
if xolox#notes#unicode_enabled()
  syntax match notesDoubleQuoted /“.\{-}”/
  syntax match notesSingleQuoted /‘.\{-}’/
else
  syntax match notesDoubleQuoted /".\{-}"/
  syntax match notesSingleQuoted /`.\{-}'/
endif
highlight def link notesSingleQuoted Special
highlight def link notesDoubleQuoted String

" Highlight text emphasized in italic font.                               {{{2
if has('conceal')
  syntax region notesItalic matchgroup=notesItalicMarker start=/\<_\k\@=/ end=/_\>\|\n/ contains=@Spell concealends
  highlight link notesItalicMarker notesHiddenMarker
else
  syntax match notesItalic /\<_\k[^_]*\k_\>/
endif
syntax cluster notesInline add=notesItalic
highlight notesItalic gui=italic

" Highlight text emphasized in bold font.                                 {{{2
if has('conceal')
  syntax region notesBold matchgroup=notesBoldMarker start=/\*\k\@=/ end=/\k\@<=\*/ contains=@Spell concealends
  highlight link notesBoldMarker notesHiddenMarker
else
  syntax match notesBold /\*\k[^*]*\k\*/
endif
syntax cluster notesInline add=notesBold
highlight notesBold gui=bold

" Highlight domain names, URLs, e-mail addresses and filenames.           {{{2

" FIXME This setting is lost once the user switches color scheme!
highlight notesSubtleURL gui=underline guifg=fg

syntax match notesTextURL @\<www\.\(\S*\w\)\+/\?@
syntax cluster notesInline add=notesTextURL
highlight def link notesTextURL notesSubtleURL
syntax match notesRealURL @\<\(mailto:\|javascript:\|\w\{3,}://\)\(\S*\w\)\+/\?@
syntax cluster notesInline add=notesRealURL
highlight def link notesRealURL notesSubtleURL
if has('conceal')
  syntax match notesUrlScheme @\(mailto:\|javascript:\|\w\{3,}://\)@ contained containedin=notesRealURL conceal
  highlight def link notesUrlScheme notesRealURL
endif
syntax match notesEmailAddr /\<\w[^@ \t\r]*\w@\w[^@ \t\r]\+\w\>/
syntax cluster notesInline add=notesEmailAddr
highlight def link notesEmailAddr notesSubtleURL
syntax match notesUnixPath /\k\@<![\/~]\S\+\(\/\|[^ [:punct:]]\)/
syntax cluster notesInline add=notesUnixPath
highlight def link notesUnixPath Directory
syntax match notesPathLnum /:\d\+/ contained containedin=notesUnixPath
highlight def link notesPathLnum Comment
syntax match notesWindowsPath /\k\@<![A-Za-z]:\S\+\([\\/]\|[^ [:punct:]]\)/
syntax cluster notesInline add=notesWindowsPath
highlight def link notesWindowsPath Directory

" Highlight TODO, DONE, FIXME and XXX markers.                            {{{2
syntax match notesTodo /\<TODO\>/
syntax match notesXXX /\<XXX\>/
syntax match notesFixMe /\<FIXME\>/
syntax match notesDoneItem /^\(\s\+\).*\<DONE\>.*\(\n\1\s.*\)*/ contains=@notesInline
syntax match notesDoneMarker /\<DONE\>/ containedin=notesDoneItem
highlight def link notesTodo WarningMsg
highlight def link notesXXX WarningMsg
highlight def link notesFixMe WarningMsg
highlight def link notesDoneItem Comment
highlight def link notesDoneMarker Question

" Highlight Vim command names in :this notation.                          {{{2
syntax match notesVimCmd /:\w\+\(!\|\>\)/ contains=ALLBUT,@Spell
syntax cluster notesInline add=notesVimCmd
highlight def link notesVimCmd Special

" Block level elements.                                                   {{{1

" The first line of each note contains the title.                         {{{2
syntax match notesTitle /^.*\%1l.*$/ contains=@notesInline
highlight def link notesTitle ModeMsg

" Short sentences ending in a colon are considered headings.              {{{2
syntax match notesShortHeading /^\s*\zs\u.\{1,50}\k:\ze\(\s\|$\)/ contains=@notesInline
highlight def link notesShortHeading Title

" Atx style headings are also supported.                                  {{{2
syntax match notesAtxHeading /^#\+.*/ contains=notesAtxMarker,@notesInline
highlight def link notesAtxHeading Title
syntax match notesAtxMarker /^#\+/ contained
highlight def link notesAtxMarker Comment

" E-mail style block quotes are highlighted as comments.                  {{{2
syntax match notesBlockQuote /\(^\s*>.*\n\)\+/ contains=@notesInline
highlight def link notesBlockQuote Comment

" Horizontal rulers.                                                      {{{2
syntax match notesRule /\(^\s\+\)\zs\*\s\*\s\*$/
highlight def link notesRule Comment

" Highlight embedded blocks of source code, log file messages, basically anything Vim can highlight.{{{2
" NB: I've escaped these markers so that Vim doesn't interpret them when editing this file…
syntax match notesCodeStart /{{[{]\w*/
syntax match notesCodeEnd /}}[}]/
highlight def link notesCodeStart Ignore
highlight def link notesCodeEnd Ignore
call xolox#notes#highlight_sources(1)

" Hide mode line at end of file.                                          {{{2
syntax match notesModeLine /\_^vim:.*\_s*\%$/
highlight def link notesModeLine LineNr

" Last edited dates in :ShowTaggedNotes buffers.
syntax match notesLastEdited /(last edited \(today\|yesterday\|\w\+, \w\+ \d\+, \d\+\))/
highlight def link notesLastEdited LineNr


" tasknotes syntax                                                        {{{1
" [TODO]( remove syntax overlap: Project & Context ) @zhaocai @start(2012-01-04 00:21)
syn region tasknotesProject matchgroup=tasknotesProject start=/^\t*\%(\u[^:]\+\)/ end=/:\%(\s\+@\w\+\%((.*)\)\=\)\{-}$/ oneline contains=tasknotesContextText,@notesInline

syn region tasknotesProjectFold start=/^\t*\%(\u[^:]\+\)/ end=/\_^\s*\_$/ transparent fold

syn region tasknotesContextText start=/\s\+@/ end=/\%(\w\+\%((.*)\)\=\)\_s/ transparent oneline contained containedin=tasknotesProject,tasknotesTask contains=tasknotesContext,tasknotesContextProperty,@notesInline
syn region tasknotesContext matchgroup=tasknotesDelimiter start=/@\%(\w\+\)\@=/ end=/\%(\_s\|(\)\@=/  contained oneline containedin=tasknotesContextText
syn region tasknotesContextProperty matchgroup=tasknotesDelimiter start="(" end=")" contained containedin=tasknotesContextText

" All bullets lists are Highlighted as Task. Only '-' counts in TaskPaper
execute 'syn region tasknotesTask matchgroup=tasknotesTaskDelimiter start=/^\%(\t*\)[' . join(g:notes_list_bullets,'') . ']\%(\s\+\)/ end=/\s*$/ oneline keepend contains=tasknotesDone,tasknotesCancelled,tasknotesContextText,@notesInline'


" Today has loweest priority
syn match tasknotesToday /\w.*\%(@[Tt]oday\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask contains=tasknotesContextText
syn match tasknotesWaiting /\w.*\%(@[Ww]aiting\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask conceal cchar=⌇ contains=tasknotesContextText
syn match tasknotesCancelled /\w.*\%(@[Cc]ance[l]\{1,2}ed\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask conceal cchar=✕ contains=tasknotesContextText
syn match tasknotesDone /\w.*\%(@[Dd]one\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask conceal cchar=✓ contains=tasknotesContextText



highlight def link tasknotesProject         Title
highlight def link tasknotesContext         Underlined
highlight def link tasknotesContextProperty Identifier
highlight def link tasknotesTask            String
highlight def link tasknotesTaskDelimiter   SpecialChar
highlight def link tasknotesDone            Comment
highlight def link tasknotesCancelled       Ignore
highlight def link tasknotesDelimiter       Delimiter

highlight tasknotesWaiting gui=italic cterm=italic
highlight tasknotesToday   guifg=hotpink ctermfg=red


" Set the currently loaded syntax mode.
let b:current_syntax = 'notes'

" vim: ts=2 sw=2 et bomb fdl=1
