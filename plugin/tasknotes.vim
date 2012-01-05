">=< Script Load Guard [[[1 ==================================================
if exists("g:loaded_taskpaper")
    finish
endif
let g:loaded_taskpaper = 1

"=============================================================================
">> Settings:                                                     [[[1
" tasknotes date format
if !exists('g:tasknotes_date_format')
    let g:tasknotes_date_format = "%Y-%m-%d"
endif

"=============================================================================
">> Public Interface:                                                     [[[1
noremap <unique> <Plug>tasknotes_toggle_done       :call tasknotes#toggle_context('done',{'attach_date' : 1, 'remove_today_context' : 1 })<CR>
noremap <unique> <Plug>tasknotes_toggle_cancelled  :call tasknotes#toggle_context('cancelled',{'attach_date' : 1 , 'remove_today_context' : 1})<CR>
noremap <unique> <Plug>tasknotes_toggle_today      :call tasknotes#toggle_context('today',{'attach_date' : 0 })<CR>
noremap <unique> <Plug>tasknotes_show_context      :call tasknotes#show_context()<CR>
noremap <unique> <Plug>tasknotes_show_all          :call tasknotes#show_all()<CR>
noremap <unique> <Plug>tasknotes_fold_all_projects :call tasknotes#fold_all_projects()<CR>


