" select by color
" adapted from Vim Tip #1269

onoremap <silent>ac :<C-u>call ColorTxtObj(0)<CR>
onoremap <silent>ic :<C-u>call ColorTxtObj(1)<CR>
vnoremap <silent>ac <Esc>:call ColorTxtObj(0)<CR><Esc>gv
vnoremap <silent>ic <Esc>:call ColorTxtObj(1)<CR><Esc>gv

function! ColorTxtObj(inner)
	let l:curline = line(".")
	let l:curcol = col(".")
	let l:lastline = line("$")
	let l:color = synIDattr(synIDtrans(synID(line("."), col("."), 1)), "fg")

	let l:p = line(".") - 1
	let l:nextSynID = synIDattr(synIDtrans(synID(l:p, min([curcol, len(getline(l:p))]), 1)), "fg")
	while l:p > 0 && l:nextSynID == l:color
		-
		let l:p = line(".") - 1
		let l:nextSynID = synIDattr(synIDtrans(synID(l:p, min([curcol, len(getline(l:p))]), 1)), "fg")
	endwhile
	if (!a:inner && l:p > 0)
		-
	endif

	normal! 0V
	call cursor(curline, 0)
	let l:p = line(".") + 1
	let l:nextSynID = synIDattr(synIDtrans(synID(l:p, min([l:curcol, len(getline(l:p))]), 1)), "fg")
	while l:p <= l:lastline && l:nextSynID == l:color
		+
		let l:p = line(".") + 1
		let l:nextSynID = synIDattr(synIDtrans(synID(l:p, min([l:curcol, len(getline(l:p))]), 1)), "fg")
	endwhile
	if (!a:inner && l:p <= l:lastline)
		+
	endif
	normal! $
endfunction 
