AutoFlog
========

Autoflog makes [flog](https://github.com/rbong/vim-flog) automatically update when any git operation is done to the corresponding repo, whether inside vim or outside.

Installation
------------

### Pre-requisites

```
pip3 install pyinotify
```

### Vim config

Using [Plug](https://github.com/junegunn/vim-plug) add the following to your `.vimrc`:

```
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'TamaMcGlinn/vim-autoflog'
```

To launch flog, use `:AutoFlog` (or `:AutoFlogsplit`) instead of the Flog commands, so that the autoflog script is 
scheduled in the background, which tells flog when to update that buffer.

For example, you could add a mapping like this in your `.vimrc`:

```
nnoremap <silent> <leader>gll :AutoFlog<CR>
```
