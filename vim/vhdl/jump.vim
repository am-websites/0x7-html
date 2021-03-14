" IMAP_Jumpfunc: takes user to next <+place-holder+> {{{
" Author: Luc Hermitte
" Arguments:
" direction: flag for the search() function. If set to '', search forwards,
"            if 'b', then search backwards. See the {flags} argument of the
"            |search()| function for valid values.
" inclusive: In vim, the search() function is 'exclusive', i.e we always goto
"            next cursor match even if there is a match starting from the
"            current cursor position. Setting this argument to 1 makes
"            IMAP_Jumpfunc() also respect a match at the current cursor
"            position. 'inclusive'ness is necessary for IMAP() because a
"            placeholder string can occur at the very beginning of a map which
"            we want to select.
"            We use a non-zero value only in special conditions. Most mappings
"            should use a zero value.

let g:Imap_DeleteEmptyPlaceHolders = 1

function! IMAP_Jumpfunc(direction, inclusive)
	let s:RemoveLastHistoryItem = ':call histdel("/", -1)|let @/=g:Tex_LastSearchPattern'
	" The user's placeholder settings.
	let phsUser = "<+"
	let pheUser = "+>"

	let searchString = ''
	" If this is not an inclusive search or if it is inclusive, but the
	" current cursor position does not contain a placeholder character, then
	" search for the placeholder characters.
	if !a:inclusive || strpart(getline('.'), col('.')-1) !~ '\V\^'.phsUser
		let searchString = '\V'.phsUser.'\_.\{-}'.pheUser
	endif

	" If we didn't find any placeholders return quietly.
	if searchString != '' && !search(searchString, a:direction)
		return ''
	endif

	" Open any closed folds and make this part of the text visible.
	silent! foldopen!

	" Calculate if we have an empty placeholder or if it contains some
	" description.
	let template = 
		\ matchstr(strpart(getline('.'), col('.')-1),
		\          '\V\^'.phsUser.'\zs\.\{-}\ze\('.pheUser.'\|\$\)')
	let placeHolderEmpty = !strlen(template)

	" If we are selecting in exclusive mode, then we need to move one step to
	" the right
	let extramove = ''
	if &selection == 'exclusive'
		let extramove = 'l'
	endif

	" Select till the end placeholder character.
	let movement = "\<C-o>v/\\V".pheUser."/e\<CR>".extramove

	" First remember what the search pattern was. s:RemoveLastHistoryItem will
	" reset @/ to this pattern so we do not create new highlighting.
	let g:Tex_LastSearchPattern = @/

	" Now either goto insert mode or select mode.
	if placeHolderEmpty && g:Imap_DeleteEmptyPlaceHolders
		" delete the empty placeholder into the blackhole.
		return movement."\"_c\<C-o>:".s:RemoveLastHistoryItem."\<CR>"
	else
		return movement."\<C-\>\<C-N>:".s:RemoveLastHistoryItem."\<CR>gv\<C-g>"
	endif
	
endfunction

" }}}
" Maps for IMAP_Jumpfunc {{{
"
" These mappings use <Plug> and thus provide for easy user customization. When
" the user wants to map some other key to jump forward, he can do for
" instance:
"   nmap ,f   <plug>IMAP_JumpForward
" etc.

" jumping forward and back in insert mode.
imap <silent> <Plug>IMAP_JumpForward    <c-r>=IMAP_Jumpfunc('', 0)<CR>
imap <silent> <Plug>IMAP_JumpBack       <c-r>=IMAP_Jumpfunc('b', 0)<CR>

" jumping in normal mode
nmap <silent> <Plug>IMAP_JumpForward        i<c-r>=IMAP_Jumpfunc('', 0)<CR>
nmap <silent> <Plug>IMAP_JumpBack           i<c-r>=IMAP_Jumpfunc('b', 0)<CR>

" deleting the present selection and then jumping forward.
vmap <silent> <Plug>IMAP_DeleteAndJumpForward       "_<Del>i<c-r>=IMAP_Jumpfunc('', 0)<CR>
vmap <silent> <Plug>IMAP_DeleteAndJumpBack          "_<Del>i<c-r>=IMAP_Jumpfunc('b', 0)<CR>

" jumping forward without deleting present selection.
vmap <silent> <Plug>IMAP_JumpForward       <C-\><C-N>i<c-r>=IMAP_Jumpfunc('', 0)<CR>
vmap <silent> <Plug>IMAP_JumpBack          <C-\><C-N>`<i<c-r>=IMAP_Jumpfunc('b', 0)<CR>

" }}}
" Default maps for IMAP_Jumpfunc {{{
" map only if there is no mapping already. allows for user customization.
" NOTE: Default mappings for jumping to the previous placeholder are not
"       provided. It is assumed that if the user will create such mappings
"       hself if e so desires.
if !hasmapto('<Plug>IMAP_JumpForward', 'i')
    imap <C-J> <Plug>IMAP_JumpForward
endif
if !hasmapto('<Plug>IMAP_JumpForward', 'n')
    nmap <C-J> <Plug>IMAP_JumpForward
endif
if exists('g:Imap_StickyPlaceHolders') && g:Imap_StickyPlaceHolders
	if !hasmapto('<Plug>IMAP_JumpForward', 'v')
		vmap <C-J> <Plug>IMAP_JumpForward
	endif
else
	if !hasmapto('<Plug>IMAP_DeleteAndJumpForward', 'v')
		vmap <C-J> <Plug>IMAP_DeleteAndJumpForward
	endif
endif
" }}}
