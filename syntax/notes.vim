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

runtime! syntax/html.vim
unlet! b:current_syntax

if !has("conceal")
  let s:tasknotes_conceal = ''
elseif !exists("g:tasknotes_conceal")
  let s:tasknotes_conceal = '#ibdla'
else
  let s:tasknotes_conceal = g:tasknotes_conceal
endif

" Check for spelling errors in all text.
syntax spell toplevel

" Inline elements.                                                        [[[1

" Cluster of elements which never contain a newline character.
syntax cluster notesInline contains=notesName

" Default highlighting style for notes syntax markers.
hi def link notesHiddenMarker Ignore

" Highlight note names as hyperlinks.                                     [[[2
call xolox#notes#highlight_names(1)
syntax cluster notesInline add=notesName
hi def link notesName Underlined


" Highlight Numbered list                                                 [[[2
syntax match notesListNumber /^\s*\zs\d\+[[:punct:]]\?\ze\s/
hi def link notesListNumber Comment

" Highlight quoted fragments.                                             [[[2
if xolox#notes#unicode_enabled()
  syntax match notesDoubleQuoted /“.\{-}”/
  syntax match notesSingleQuoted /‘.\{-}’/
else
  syntax match notesDoubleQuoted /".\{-}"/
  syntax match notesSingleQuoted /`.\{-}'/
endif
hi def link notesSingleQuoted Special
hi def link notesDoubleQuoted String

" Highlight text emphasized in italic font.                               [[[2
if s:tasknotes_conceal =~# 'i'
  syntax region notesItalic matchgroup=notesItalicMarker start=/\<_\k\@=/ end=/_\>\|\n/ contains=@Spell concealends
  highlight link notesItalicMarker notesHiddenMarker
else
  syntax match notesItalic /\<_\k[^_]*\k_\>/
endif
syntax cluster notesInline add=notesItalic
highlight notesItalic gui=italic

" Highlight text emphasized in bold font.                                 [[[2
if s:tasknotes_conceal =~# 'b'
  syntax region notesBold matchgroup=notesBoldMarker start=/\*\k\@=/ end=/\k\@<=\*/ contains=@Spell concealends
  highlight link notesBoldMarker notesHiddenMarker
else
  syntax match notesBold /\*\k[^*]*\k\*/
endif
syntax cluster notesInline add=notesBold
highlight notesBold gui=bold

" Highlight domain names, URLs, e-mail addresses and filenames.           [[[2

" FIXME This setting is lost once the user switches color scheme!
highlight notesSubtleURL gui=underline guifg=fg

syntax match notesTextURL @\<www\.\(\S*\w\)\+/\?@
syntax cluster notesInline add=notesTextURL
hi def link notesTextURL notesSubtleURL
syntax match notesRealURL @\<\(mailto:\|javascript:\|\w\{3,}://\)\(\S*\w\)\+/\?@
syntax cluster notesInline add=notesRealURL
hi def link notesRealURL notesSubtleURL
if s:tasknotes_conceal =~# 'l'
  syntax match notesUrlScheme @\(mailto:\|javascript:\|\w\{3,}://\)@ contained containedin=notesRealURL conceal
  hi def link notesUrlScheme notesRealURL
endif
syntax match notesEmailAddr /\<\w[^@ \t\r]*\w@\w[^@ \t\r]\+\w\>/
syntax cluster notesInline add=notesEmailAddr
hi def link notesEmailAddr notesSubtleURL
syntax match notesUnixPath /\k\@<![\/~]\S\+\(\/\|[^ [:punct:]]\)/
syntax cluster notesInline add=notesUnixPath
hi def link notesUnixPath Directory
syntax match notesPathLnum /:\d\+/ contained containedin=notesUnixPath
hi def link notesPathLnum Comment
syntax match notesWindowsPath /\k\@<![A-Za-z]:\S\+\([\\/]\|[^ [:punct:]]\)/
syntax cluster notesInline add=notesWindowsPath
hi def link notesWindowsPath Directory

" Highlight TODO, DONE, FIXME and XXX markers.                            [[[2
syntax match notesTodo /\<TODO\>/
syntax match notesXXX /\<XXX\>/
syntax match notesFixMe /\<FIXME\>/
syntax match notesDoneItem /^\(\s\+\).*\<DONE\>.*\(\n\1\s.*\)*/ contains=@notesInline
syntax match notesDoneMarker /\<DONE\>/ containedin=notesDoneItem
hi def link notesTodo WarningMsg
hi def link notesXXX WarningMsg
hi def link notesFixMe WarningMsg
hi def link notesDoneItem Comment
hi def link notesDoneMarker Question

" Highlight Vim command names in :this notation.                          [[[2
syntax match notesVimCmd /:\w\+\(!\|\>\)/ contains=ALLBUT,@Spell
syntax cluster notesInline add=notesVimCmd
hi def link notesVimCmd Special

" Block level elements.                                                   [[[1

" The first line of each note contains the title.                         [[[2
syntax match notesTitle /^.*\%1l.*$/ contains=@notesInline
hi def link notesTitle ModeMsg

" Short sentences ending in a colon are considered headings.              [[[2
syntax match notesShortHeading /^\s*\zs\u.\{1,50}\k:\ze\(\s\|$\)/ contains=@notesInline
hi def link notesShortHeading Title


" E-mail style block quotes are highlighted as comments.                  [[[2
syntax match notesBlockQuote /\(^\s*>.*\n\)\+/ contains=@notesInline
hi def link notesBlockQuote Comment

" Horizontal rulers.                                                      [[[2
syntax match notesRule /\(^\s\+\)\zs\*\s\*\s\*$/
hi def link notesRule Comment

" Highlight embedded blocks of source code, logfilemessages,basicallyanythingVimcanhighlight.[[[2
" NB: I've escaped these markers so that Vim doesn't interpret them when editing this file…
syntax match notesCodeStart /{{[{]\w*/
syntax match notesCodeEnd /}}[}]/
hi def link notesCodeStart Ignore
hi def link notesCodeEnd Ignore
call xolox#notes#highlight_sources(1)

" Hide mode line at end of file.                                          [[[2
syntax match notesModeLine /\_^vim:.*\_s*\%$/
hi def link notesModeLine LineNr

" Last edited dates in :ShowTaggedNotes buffers.
syntax match notesLastEdited /(last edited \(today\|yesterday\|\w\+, \w\+ \d\+, \d\+\))/
hi def link notesLastEdited LineNr


"▶ TaskNotes Syntax ▼  [[[1 =======================================================
"
" Atx style headings are supported.                                       [[[2
syn region tasknotesProjectH1 start=/^\%(#\{0,6}\s*\)\%(\u[^:]\+\)/ end=/:\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ oneline keepend contains=tasknotesContextText,@notesInline,tasknotesAtxMarker
syn region tasknotesProjectH2 start=/^\%(\t\u[^:]\+\)/ end=/:\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ oneline contains=tasknotesContextText,@notesInline
syn region tasknotesProjectH3 start=/^\%(\t\t\u[^:]\+\)/ end=/:\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ oneline contains=tasknotesContextText,@notesInline

syn region tasknotesProjectFold start=/^\t*\%(\u[^:]\+\)/ end=/\_^\s*\_$/ transparent fold

" Conceal Leading '#'
if s:tasknotes_conceal =~# 'a'
  syntax match tasknotesAtxMarker /^#\+/ conceal cchar=☯ contained containedin=tasknotesProjectH1
else
  syntax match tasknotesAtxMarker /^#\+/ contained containedin=tasknotesProjectH1
endif

" Highlight @context(.*)                                                  [[[2
syn region tasknotesContextText start=/\s\+@/ end=/\%(\w\+\%((.*)\)\=\)\_s/ transparent oneline contained containedin=tasknotesProject,tasknotesTask contains=tasknotesContext,tasknotesContextProperty,@notesInline
syn region tasknotesContext matchgroup=tasknotesDelimiter start=/@\%(\w\+\)\@=/ end=/\%(\_s\|(\)\@=/  contained oneline containedin=tasknotesContextText
syn region tasknotesContextProperty matchgroup=tasknotesDelimiter start="(" end=")" contained containedin=tasknotesContextText

" All bullets lists are Highlighted as Task. Only '-' counts in TaskPaper
execute 'syn region tasknotesTask matchgroup=tasknotesTaskDelimiter start=/^\%(\t*\)[' . join(g:notes_list_bullets,'') . ']\%(\s\+\)/ end=/\s*$/ oneline keepend contains=tasknotesDone,tasknotesCancelled,tasknotesContextText,@notesInline'


" Today has loweest priority
syn match tasknotesToday /\w.*\%(@[Tt]oday\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask contains=tasknotesContextText
if s:tasknotes_conceal =~# 'l'
  syn match tasknotesWaiting /\w.*\%(@[Ww]aiting\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask conceal cchar=⌇ contains=tasknotesContextText
  syn match tasknotesCancelled /\w.*\%(@[Cc]ance[l]\{1,2}ed\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask conceal cchar=✕ contains=tasknotesContextText
  syn match tasknotesDone /\w.*\%(@[Dd]one\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask conceal cchar=✓ contains=tasknotesContextText
else
  syn match tasknotesToday /\w.*\%(@[Tt]oday\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask contains=tasknotesContextText
  syn match tasknotesWaiting /\w.*\%(@[Ww]aiting\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask contains=tasknotesContextText
  syn match tasknotesCancelled /\w.*\%(@[Cc]ance[l]\{1,2}ed\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask contains=tasknotesContextText
  syn match tasknotesDone /\w.*\%(@[Dd]one\%((.*)\)\=\)\%(\s\+@\w\+\%((.*)\)\=\)\{}$/ contained containedin=tasknotesTask contains=tasknotesContextText
endif

if s:tasknotes_conceal =~# 'd'
  syn region tasknotesIdDeclaration matchgroup=tasknotesLinkDelimiter start="^ \{0,3\}!\=\[" end="\]\ze:" oneline keepend nextgroup=tasknotesUrl skipwhite concealends
else
  syn region tasknotesIdDeclaration matchgroup=tasknotesLinkDelimiter start="^ \{0,3\}!\=\[" end="\]:" oneline keepend nextgroup=tasknotesUrl skipwhite
endif

" markdown style link.                                                    [[[2
syn match tasknotesUrl "\S\+" nextgroup=tasknotesUrlTitle skipwhite contained
syn region tasknotesUrl matchgroup=tasknotesUrlDelimiter start="<" end=">" oneline keepend nextgroup=tasknotesUrlTitle skipwhite contained
syn region tasknotesUrlTitle matchgroup=tasknotesUrlTitleDelimiter start=+"+ end=+"+ keepend contained
syn region tasknotesUrlTitle matchgroup=tasknotesUrlTitleDelimiter start=+'+ end=+'+ keepend contained
syn region tasknotesUrlTitle matchgroup=tasknotesUrlTitleDelimiter start=+(+ end=+)+ keepend contained

if s:tasknotes_conceal =~# 'l'
  syn region tasknotesLinkText matchgroup=tasknotesLinkTextDelimiter start="!\=\[\%(\_[^]]*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" keepend nextgroup=tasknotesLink,tasknotesId skipwhite contains=@tasknotesInline,tasknotesLineStart concealends
  syn region tasknotesLink matchgroup=tasknotesLinkDelimiter start="(" end=")" contains=tasknotesUrl keepend contained conceal
  syn region tasknotesId matchgroup=tasknotesIdDelimiter start="\s*\[" end="\]" keepend contained conceal
else
  syn region tasknotesLinkText matchgroup=tasknotesLinkTextDelimiter start="!\=\[\%(\_[^]]*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" keepend nextgroup=tasknotesLink,tasknotesId skipwhite contains=@tasknotesInline,tasknotesLineStart
  syn region tasknotesLink matchgroup=tasknotesLinkDelimiter start="(" end=")" contains=tasknotesUrl keepend contained
  syn region tasknotesId matchgroup=tasknotesIdDelimiter start="\[" end="\]" keepend contained
endif

if s:tasknotes_conceal =~# 'a'
  syn region tasknotesAutomaticLink matchgroup=tasknotesUrlDelimiter start="<\%(\w\+:\|[[:alnum:]_+-]\+@\)\@=" end=">" keepend oneline concealends
else
  syn region tasknotesAutomaticLink matchgroup=tasknotesUrlDelimiter start="<\%(\w\+:\|[[:alnum:]_+-]\+@\)\@=" end=">" keepend oneline
endif


hi def link tasknotesProjectH1       htmlH1
hi def link tasknotesProjectH2       htmlH2
hi def link tasknotesProjectH3       htmlH3
hi def link tasknotesAtxMarker       Comment

hi def link tasknotesContext         Underlined
hi def link tasknotesContextProperty Identifier
hi def link tasknotesTask            String
hi def link tasknotesTaskDelimiter   SpecialChar
hi def link tasknotesDone            Comment
hi def link tasknotesCancelled       Ignore
hi def link tasknotesDelimiter       Delimiter

highlight tasknotesWaiting gui=italic cterm=italic
highlight tasknotesToday   guifg=hotpink ctermfg=red


hi def link tasknotesLinkText              htmlLink
hi def link tasknotesIdDeclaration         Typedef
hi def link tasknotesId                    Type
hi def link tasknotesAutomaticLink         tasknotesUrl
hi def link tasknotesUrl                   Float
hi def link tasknotesUrlTitle              String
hi def link tasknotesIdDelimiter           tasknotesLinkDelimiter
hi def link tasknotesUrlDelimiter          htmlTag
hi def link tasknotesUrlTitleDelimiter     Delimiter

" Set the currently loaded syntax mode.
let b:current_syntax = 'notes'

"▲ Modeline ◀  [[[1 =========================================================
" vim: ts=2 sw=2 et bomb fmr=[[[,]]] fdm=marker fdl=1
