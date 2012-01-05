

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

fun! tasknotes#toggle_context(context,...)"                               [[[1
" toggle context like done cancelled ...
    let opt =  a:0 >= 1 && type(a:1) == type({})  ?  a:1  :  {}
    let is_attach_date = get(opt, 'attach_date', 0)
    let context = '@' . a:context

    let line = getline(".")
    if (line =~ '^\t*- ')
        let repl = line

        if (line =~ context )
            let repl = substitute(line, context . '\(.*\)', "", "g")
            if &verbose > 1 | echo "undo " . context . "!" | endif
        else
            if is_attach_date
                let today = strftime(g:tasknotes_date_format, localtime())
                let context_str = " " . context . "(" . today . ")"
            else
                let context_str = " " . context
            endif
            let repl = substitute(line, "$", context_str, "g")
            if &verbose > 1 | echo context . "!" | endif
        endif
        call setline(".", repl)
    else
        echo "not a task."
    endif

    exec 'silent! call repeat#set("\<Plug>tasknotes_toggle_' . a:context . '")'
endf



">=< Modeline [[[1 ===========================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fmr=[[[,]]] fdm=marker fdl=1 :
