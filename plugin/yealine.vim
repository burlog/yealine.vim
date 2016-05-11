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
    autocmd WinLeave,WinEnter,BufWinEnter * let &l:statusline="%!yealine#YeaLine(".bufnr("%").")"
    autocmd TabLeave,TabEnter             * let &l:tabline="%!yealine#YeaTabLine()"
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
\    "ModeNormal":      [0, 39],
\    "ModeInsert":      [0, 34],
\    "ModeReplace":     [0, 202],
\    "ModeVisual":      [0, 220],
\    "ModeCommand":     [0, 39],
\    "ModeSelect":      [0, 220],
\    "TabBase":         [0, 240],
\    "TabClose":        [246, 236],
\    "TabEntryCurrent": [0, 34],
\    "TabEntry":        [[0, 237], [0, 236]],
\ }

let g:_yealine_mode_map = {
\    "n":      [g:yealine_colors["ModeNormal"], "NORMAL "],
\    "i":      [g:yealine_colors["ModeInsert"], "INSERT "],
\    "R":      [g:yealine_colors["ModeReplace"], "REPLACE"],
\    "v":      [g:yealine_colors["ModeVisual"], "VISUAL "],
\    "V":      [g:yealine_colors["ModeVisual"], "V-LINE "],
\    "\<C-v>": [g:yealine_colors["ModeVisual"], "V-BLOCK"],
\    "c":      [g:yealine_colors["ModeCommand"], "COMMAND"],
\    "s":      [g:yealine_colors["ModeSelect"], "SELECT "],
\    "S":      [g:yealine_colors["ModeSelect"], "S-LINE "],
\    "\<C-s>": [g:yealine_colors["ModeSelect"], "S-BLOCK"],
\ }

let g:_yealine_handle_spec = 1
let g:_yealine_separator_inverse = 0
let g:_yealine_separators = ["⮀", "⮂"]
let g:_yealine_left_boxes =  ["yealine#boxes#Buffer", "yealine#boxes#Mode", "yealine#boxes#Readonly", "yealine#boxes#Modified", "yealine#boxes#Paste", "yealine#boxes#Syntax", "yealine#boxes#Filename"]
let g:_yealine_right_boxes = ["yealine#boxes#Position", "yealine#boxes#CurrentChar"]

let g:_yealine_tab_separator_inverse = 0
let g:_yealine_tab_separators = g:_yealine_separators
let g:_yealine_tab_left_boxes =  ["yealine#boxes#TabEntry"]
let g:_yealine_tab_right_boxes = ["yealine#boxes#TabClose"]

let &cpo = s:save_cpo
unlet s:save_cpo

