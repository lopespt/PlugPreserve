function! PlugUpdatePreserve()
  let plug=g:plug_home
  let stashCmd="cd " . plug . "; for x in $(ls " . plug . "/ );do cd $x;  git stash; cd .. ;done;"
  echo stashCmd
  echo "Stashing"
  call system(stashCmd)
  echo "Stashed"
  echo "Updating"
  PlugUpdate
  echo "Updated"

endfunction

function! AfterUpdate()
  au! PlugUpdatePreserve TextChanged 
  echo "Unstashing"
  let plug=g:plug_home
  let stashCmd="cd " . plug . "; for x in $(ls " . plug . ");do cd $x; git stash pop; "."; cd .. ;done;"
  let result=systemlist(stashCmd)
  new
  set hidden
  set nobuflisted
  set buftype=nofile
  set bufhidden=wipe
  call append(0,result)
  echo "Unstashed"
endfunction

function! CheckEnd()
  normal gg0
  if search("Updated","c",1)
    call AfterUpdate()
  endif

endfunction

command! PlugUpdatePreserve call PlugUpdatePreserve()

augroup PlugUpdatePreserve
  " this one is which you're most likely to use?
  autocmd filetype vim-plug au PlugUpdatePreserve TextChanged <buffer> call CheckEnd()
augroup end







