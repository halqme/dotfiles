set incsearch
set ttyfast
set showtabline=2

set encoding=utf-8

" 改行コードの自動判別
set fileformats=unix,dos,mac

"file profile config
set nobomb
"swpファイル保存ディレクトリ

set showcmd

"文字列検索時のハイライト有効化
set hlsearch

"copy, cut, paste config
set clipboard=unnamed,autoselect

"setting indent
set autoindent
set smartindent
set breakindent

"status line ever indicate
set laststatus=2
set autowrite

set nobackup
set noswapfile

"tab & visual UI settings
set shiftwidth=4
set tabstop=4
set noexpandtab
set title

"color scheme setting::
syntax enable

"use multibyte character setting
set ambiwidth=double

set number
set relativenumber

packadd vim-jetpack

call jetpack#begin()
    Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap
    Jetpack 'catppuccin/vim', { 'event': ['BufRead'], 'as': 'catppuccin' }
    Jetpack 'tpope/vim-surround', { 'event': ['BufRead']}
    Jetpack 'tpope/vim-repeat', { 'event': ['BufRead']}
    Jetpack 'kaz399/spzenhan.vim'
    Jetpack 'lambdalisue/fern.vim'

    Jetpack 'raghur/vim-ghost'
    Jetpack 'vim-scripts/YankRing.vim'

    Jetpack 'itchyny/lightline.vim'

    Jetpack 'prabirshrestha/vim-lsp'
    Jetpack 'prabirshrestha/asyncomplete.vim'
    Jetpack 'nathanaelkane/vim-indent-guides'
    Jetpack 'roxma/nvim-yarp'
    Jetpack 'mattn/vim-maketable'
    Jetpack 'obcat/vim-hitspop'
call jetpack#end()
