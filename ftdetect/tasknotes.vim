" Vim filetype detection file
" Language:
" Maintainer:
" URL:
" Last Change:  Tue 03 Jan 2012 11:14:51 PM EST
"
augroup ftdetect_tasknotes
    au!
    au! BufRead,BufNewFile *.taskpaper,*.tasknotes setfiletype notes
augroup END
