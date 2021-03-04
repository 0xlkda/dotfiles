let g:thealemazing_colorscheme = "gruvbox"

fun! PaintMyWorld()
	let g:gruvbox_invert_selection = 0
	colorscheme gruvbox
endfun
call PaintMyWorld()

" Vim with me
nnoremap <leader>vwm :call PaintMyWorld()<CR>
nnoremap <leader>vwb :let g:thealemazing_colorscheme =
