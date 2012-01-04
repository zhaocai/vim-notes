">=< Script Load Guard [[[1 ==================================================
if exists("g:loaded_taskpaper")
    finish
endif
let g:loaded_taskpaper = 1

"=============================================================================
">> Public Interface:                                                     [[[1
noremap <unique> <Plug>tasknotes_toggle_done       :call tasknotes#toggle_done()<CR>
noremap <unique> <Plug>tasknotes_toggle_cancelled  :call tasknotes#toggle_cancelled()<CR>
noremap <unique> <Plug>tasknotes_show_context      :call tasknotes#show_context()<CR>
noremap <unique> <Plug>tasknotes_show_all          :call tasknotes#show_all()<CR>
noremap <unique> <Plug>tasknotes_fold_all_projects :call tasknotes#fold_all_projects()<CR>


