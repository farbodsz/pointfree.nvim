if !has('nvim-0.5')
  echo 'pointfree.nvim requires NVIM 0.5 or higher'
  finish
endif

if exists('g:pointfree_nvim_loaded')
  finish
endif

" Save user options then reset them to defaults
let s:save_cpo = &cpo
set cpo&vim

command! Pointfree lua require'pointfree'.pointfree()

" Restore user options
let &cpo = s:save_cpo
unlet s:save_cpo


let g:pointfree_nvim_loaded = 1
