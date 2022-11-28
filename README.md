# AutoFlog

Autoflog makes [flog](https://github.com/rbong/vim-flog) automatically update when any git operation is done to the corresponding repo, whether inside vim or outside.

## Installation

Using [Plug](https://github.com/junegunn/vim-plug) add the following to your `.vimrc`:

```
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'TamaMcGlinn/flog-menu'
Plug 'TamaMcGlinn/vim-autoflog'
```

To launch flog, use `call autoflog#open_flog()` so that the autoflog script is scheduled in the background, which tells flog when to update. For example, you could add a mapping like this in your `.vimrc`:

```
nnoremap <silent> <leader>gll :call autoflog#open_flog()<CR>
```