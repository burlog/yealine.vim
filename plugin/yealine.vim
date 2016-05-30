" yaline.vim - Yet Another Vim Status Line
" Maintainer:   Michal Bukovsky <burlog@seznam.cz>
" Licence:      MIT

if exists("g:loaded_yealine") || v:version < 700
  finish
endif
let g:loaded_yealine = 1

let s:save_cpo = &cpo
set cpo&vim

augroup YeaLine
    autocmd!
    autocmd WinEnter,BufWinEnter * let &l:statusline="%!yealine#YeaLine(".win_getid().")"
    autocmd WinLeave,BufWinLeave * let &l:statusline="%!yealine#YeaLine(".win_getid().")"
    autocmd TabLeave,TabEnter    * let &l:tabline="%!yealine#YeaTabLine()"
augroup END

let g:_yealine_colors = {
\    "Base":            [0, 242],
\    "BaseCurrent":     [0, 250],
\    "Buffer":          [243, 236],
\    "Readonly":        [0, 160],
\    "Modified":        [0, 220],
\    "Paste":           [0, 220],
\    "Syntax":          [[248, 241], [249, 18]],
\    "Position":        [[248, 241], [249, 18]],
\    "CurrentChar":     [243, 236],
\    "ModeNormal":      [0, 39],
\    "ModeInsert":      [0, 34],
\    "ModeReplace":     [0, 202],
\    "ModeVisual":      [0, 220],
\    "ModeCommand":     [0, 39],
\    "ModeSelect":      [0, 220],
\    "TabBase":         [0, 240],
\    "TabClose":        [246, 236],
\    "TabEntryCurrent": [0, 34],
\    "TabEntry":        [[245, 236], [245, 238]],
\ }

let g:_yealine_mode_map = {
\    "n":      [g:_yealine_colors["ModeNormal"], "NORMAL "],
\    "i":      [g:_yealine_colors["ModeInsert"], "INSERT "],
\    "R":      [g:_yealine_colors["ModeReplace"], "REPLACE"],
\    "v":      [g:_yealine_colors["ModeVisual"], "VISUAL "],
\    "V":      [g:_yealine_colors["ModeVisual"], "V-LINE "],
\    "\<C-v>": [g:_yealine_colors["ModeVisual"], "V-BLOCK"],
\    "c":      [g:_yealine_colors["ModeCommand"], "COMMAND"],
\    "s":      [g:_yealine_colors["ModeSelect"], "SELECT "],
\    "S":      [g:_yealine_colors["ModeSelect"], "S-LINE "],
\    "\<C-s>": [g:_yealine_colors["ModeSelect"], "S-BLOCK"],
\ }

let g:_yealine_inactive_cache_timeout = 3

let g:_yealine_separator_inverse = 0
let g:_yealine_separators = ["⮀", "⮂"]
let g:_yealine_left_boxes =  ["yealine#boxes#Mode", "yealine#boxes#Readonly", "yealine#boxes#Modified", "yealine#boxes#Paste", "yealine#boxes#Syntax", "yealine#boxes#Filename"]
let g:_yealine_right_boxes = ["yealine#boxes#Position"]
let g:_yealine_handle_special = ["nofile"]
let g:_yealine_special_left_boxes = ["yealine#boxes#Filename"]
let g:_yealine_special_right_boxes = []
let g:_yealine_middle_color_function = "yealine#boxes#MiddleColor"

let g:_yealine_tab_separator_inverse = 0
let g:_yealine_tab_separators = g:_yealine_separators
let g:_yealine_tab_left_boxes =  ["yealine#boxes#TabEntry"]
let g:_yealine_tab_right_boxes = ["yealine#boxes#TabClose"]

let &cpo = s:save_cpo
unlet s:save_cpo

