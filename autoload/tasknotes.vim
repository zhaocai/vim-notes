

"show tasks from context under the cursor
fun! tasknotes#show_context()"                                            [[[1
    let s:wordUnderCursor = expand("<cword>")
    if(s:wordUnderCursor =~ "@\k*")
        let @/ = "\\<".s:wordUnderCursor."\\>"


        let b:undo_show_context = zlib#rc#set_undo( ['foldexpr' , 'foldmethod', 'foldlevel',
                        \ 'foldcolumn', 'foldminlines' , 'conceallevel'
                    \ ])
        setlocal foldexpr=(getline(v:lnum)=~@/)?0:1
        setlocal foldmethod=expr foldlevel=0 foldcolumn=1 foldminlines=0
        setlocal conceallevel=0

    else
        echo "'" s:wordUnderCursor "' is not a context."
    endif
    silent! call repeat#set("\<Plug>tasknotes_show_context")
endf

fun! tasknotes#show_all()"                                                [[[1
    call zlib#rc#undo('b:undo_show_context')
    silent! %foldopen!
    setlocal nofoldenable

    silent! call repeat#set("\<Plug>tasknotes_show_all")
endf

fun! tasknotes#fold_all_projects()"                                       [[[1
    call zlib#rc#undo('b:undo_show_context')
    setlocal foldenable
    silent! %foldclose!

    silent! call repeat#set("\<Plug>tasknotes_fold_all_projects")
endf

fun! tasknotes#toggle_context(context,...)"                               [[[1
" toggle context like done cancelled ...
    let opt =  a:0 >= 1 && type(a:1) == type({})  ?  a:1  :  {}
    let is_attach_date = get(opt, 'attach_date', 0)
    let is_remove_today_context = get(opt, 'remove_today_context', 0)
    let context = '@' . a:context

    let line = getline(".")
    let context_prefix = line =~# '\s\+$' ? '' : ' '
    if (line =~ '^\t*- ')
        let repl = line

        if (line =~ context )
            let repl = substitute(repl, context . '\(.*\)', "", "g")
            if &verbose > 1 | echo "undo " . context . "!" | endif
        else
            if is_attach_date == 1
                let today = strftime(g:tasknotes_date_format, localtime())
                let context_str = context_prefix . context . "(" . today . ")"
            else
                let context_str = context_prefix . context
            endif
            if is_remove_today_context == 1
                let repl = substitute(repl, '@[Tt]oday', "", "g")
            endif
            let repl = substitute(repl, "$", context_str, "g")
            if &verbose > 1 | echo 'add ' . context . "!" | endif
        endif
        call setline(".", repl)
    else
        echo "not a task."
    endif

    exec 'silent! call repeat#set("\<Plug>tasknotes_toggle_' . a:context . '")'
endf



">=< Modeline [[[1 ===========================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fmr=[[[,]]] fdm=marker fdl=1 :
