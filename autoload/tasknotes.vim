

"show tasks from context under the cursor
fun! tasknotes#show_context()"                                            [[[1
    let s:wordUnderCursor = expand("<cword>")
    if(s:wordUnderCursor =~ "@\k*")
        let @/ = "\\<".s:wordUnderCursor."\\>"
        "adapted from http://vim.sourceforge.net/tips/tip.php?tip_id=282
        setlocal foldexpr=(getline(v:lnum)=~@/)?0:1
        setlocal foldmethod=expr foldlevel=0 foldcolumn=1 foldminlines=0
        setlocal foldenable
        setlocal conceallevel=0
    else
        echo "'" s:wordUnderCursor "' is not a context."
    endif
    silent! call repeat#set("\<Plug>tasknotes_show_context")
endf

fun! tasknotes#show_all()"                                                [[[1
    setlocal foldmethod=syntax
    silent! %foldopen!
    setlocal nofoldenable
    setlocal conceallevel=0

    silent! call repeat#set("\<Plug>tasknotes_show_all")
endf

fun! tasknotes#fold_all_projects()"                                       [[[1
    setlocal foldmethod=syntax
    setlocal foldenable
    setlocal conceallevel=0
    silent! %foldclose!

    silent! call repeat#set("\<Plug>tasknotes_fold_all_projects")
endf

" toggle @done context tag on a task
fun! tasknotes#toggle_done()"                                             [[[1

    let line = getline(".")
    if (line =~ '^\t*- ')
        let repl = line
        if (line =~ '@done')
            let repl = substitute(line, "@done\(.*\)", "", "g")
            if &verbose > 1 | echo "undone!" | endif
        else
            let today = strftime(g:tasknotes_date_format, localtime())
            let done_str = " @done(" . today . ")"
            let repl = substitute(line, "$", done_str, "g")
            if &verbose > 1 | echo "done!" | endif
        endif
        call setline(".", repl)
    else
        echo "not a task."
    endif

    silent! call repeat#set("\<Plug>tasknotes_toggle_done")
endf

" toggle @cancelled context tag on a task
fun! tasknotes#toggle_cancelled()"                                        [[[1

    let line = getline(".")
    if (line =~ '^\t*- ')
        let repl = line
        if (line =~ '@cancelled')
            let repl = substitute(line, "@cancelled\(.*\)", "", "g")
            echo "uncancelled!"
        else
            let today = strftime(g:tasknotes_date_format, localtime())
            let cancelled_str = " @cancelled(" . today . ")"
            let repl = substitute(line, "$", cancelled_str, "g")
            echo "cancelled!"
        endif
        call setline(".", repl)
    else
        echo "not a task."
    endif

    silent! call repeat#set("\<Plug>tasknotes_toggle_cancelled")
endf




">=< Modeline [[[1 ===========================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fmr=[[[,]]] fdm=marker fdl=1 :
