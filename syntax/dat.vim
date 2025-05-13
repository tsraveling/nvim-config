" Vim syntax file for .dat game files
" Language: dat
" Maintainer: You
" Latest Revision: Today

if exists("b:current_syntax")
  finish
endif

" Comments
syntax match datComment "#.*$"

" Integer with - + or nothing in front
syntax match datNumber '\<[-+]\?\d\+\>'

" Floating point number with decimal no E or e 
syntax match datFloat '[-+]\?\d\+\.\d*'

" Define highlighting
highlight default link datComment Comment
highlight default link datNumber Constant
highlight default link datFloat Constant

let b:current_syntax = "dat"
