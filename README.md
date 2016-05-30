# Yet Another Vim Status Line

This is very simple and highly customizable implementation of the vim statusline.

Default look
![yealine.vim - default](https://raw.githubusercontent.com/wiki/burlog/yealine.vim/img/yealine4.png)

Default look with patched font
![yealine.vim - patched fonts](https://raw.githubusercontent.com/wiki/burlog/yealine.vim/img/yealine1.png)

Customized
![yealine.vim - customized](https://raw.githubusercontent.com/wiki/burlog/yealine.vim/img/yealine3.png)

## Why I wrote another statusline

 * It natively supports more Vim windows in one tab - show buffer flags for
   which is loaded in the window,
 * is, I hope, simple and easy to customizable - you can write your own box -
   its a vim function that return string and color,
 * and finally, I enjoy it and it contains my own bugs :).

## Installation

Yealine should be compatible with most plugin managers, like Pathogen or Vundle.

### Vundle

Just add

```vim
Plugin 'burlog/yealine.vim'
```

into your .vimrc and run

```sh
vim +PluginInstall
```

### Manual

If you don't use any plugin manager, you can copy all files into Vim runtime directory.

## Configuration

### Content

You don't need do anything and Yealine runs for you. But if it doesn't look like
you want, it should be easy to change.

Statusline is splited into left and right part for that you can define list of
boxes. In each list you can put any predefined box that you can found at
![boxes.vim](https://github.com/burlog/yealine.vim/blob/master/autoload/yealine/boxes.vim)
.

Here is incomplete list of this:

* `yealine#boxes#Buffer` - current buffer number,
* `yealine#boxes#Mode` - current mode,
* `yealine#boxes#Readonly` - readonly flag,
* `yealine#boxes#Modified` - modified flag,
* `yealine#boxes#Paste` - paste flag,
* `yealine#boxes#Filename` - filename of the buffer,
* `yealine#boxes#Syntax` - current syntax,
* `yealine#boxes#CurrentChar` - dec code of the char under the cursor,
* `yealine#boxes#Position` - current position of the curser in the window.

And for tabline:

* `yealine#boxes#TabEntry` - entry in tabline for tab,
* `yealine#boxes#TabClose` - close entry.

Very simplistic statusline that contains only current mode and filename on the
left side and position in the file on right side can be defined with this:

```vim
let g:yealine_left_boxes =  ["yealine#boxes#Mode", "yealine#boxes#Filename"]
let g:yealine_right_boxes = ["yealine#boxes#Position"]
```

You probably some tine open special windows (:help special-buffers) like
quickfix, preview and others. You can define for which buffers should be used
separate list of boxes via `g:yealine_handle_special` configuration variable.
This variable should contain a list with special buffer types. Yealine will use
the separate lists for content of the statusline for all windows that contain
buffers with given types.

```vim
let g:yealine_handle_special = ["nofile"]
let g:yealine_special_left_boxes = ["yealine#boxes#Filename"]
let g:yealine_special_right_boxes = []
```

Tabline is defined in same way:

```vim
let g:_yealine_tab_left_boxes =  ["yealine#boxes#TabEntry"]
let g:_yealine_tab_right_boxes = ["yealine#boxes#TabClose"]
```

### Colors

The colors for predefined boxes you can change in `g:yealine_colors` dictionary:

```vim
let g:yealine_colors = {
\    "Base":            [0,    242],
\    "BaseCurrent":     [0,    250],
\    "Buffer":          [243,  236],
\    "Readonly":        [0,    160],
\    "Modified":        [0,    220],
\    "Paste":           [0,    220],
\    "Syntax":          [[248, 241], [249, 18]],
\    "Position":        [[248, 241], [249, 18]],
\    "CurrentChar":     [243,  236],
\    "ModeNormal":      [0,    39],
\    "ModeInsert":      [0,    34],
\    "ModeReplace":     [0,    202],
\    "ModeVisual":      [0,    220],
\    "ModeCommand":     [0,    39],
\    "ModeSelect":      [0,    220],
\    "TabBase":         [0,    240],
\    "TabClose":        [246,  236],
\    "TabEntryCurrent": [0,    34],
\    "TabEntry":        [[245, 236], [245, 238]],
\ }
```

The color is defined with two or four length array of color numbers/strings like
Vim highlight command accepts. The first is ctermfg, second is ctermbg and
optional third is guifg and fourth is guibg. If you don't state gui\* variants
YeaLine calculate proper values from builtin table.

So full color specification looks like this:

```vim
let g:yealine_colors["TabClose"] = [0, 34, "#000000", "#00af00"]
```

If array contains another arrays instead of color numbers/strings. Then, for status
line, YeaLine uses the first one entry for active window and second one for
inactive windows. And for tabline, Yealine choose (i % mod(len(list)))-nth
color from this list for tab at index i.

The next dictionary contains map of mode titles and colors so if you don't
satisfied with default feel free to change it:

```vim
let g:yealine_mode_map = {
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
```

If you wan't to change base/middle color based on some conditions you can
override base color getter with you own like bellow:

```
let g:yealine_middle_color_function = "YourMiddleColor"

function! YourMiddleColor(active, bufno)
    if a:active
        return yealine#boxes#Mode(a:active, a:bufno)[0]
    endif
    return yealine#BaseColor(a:active)
endfunction
```

For performance purposes statusline definition for inactive buffers are cached.
The default cache timeout is 3 seconds.

```vim
let g:yealine_inactive_cache_timeout = 3
```

## Custom fonts

![yealine.vim - patched fonts](https://raw.githubusercontent.com/wiki/burlog/yealine.vim/img/yealine1.png)

The statusline on the image above uses patched font for drawing boxes. You need
to patch your font so you have got suitable separators characters. There is
some guides to patch your fonts, nice two you found here:

+ [vim-powerline](https://github.com/Lokaltog/vim-powerline)
+ [powerline](https://github.com/Lokaltog/powerline)

Next you can define separators, for statusline:

```vim
let g:yealine_separators = ["⮀", "⮂"]
let g:yealine_separator_inverse = 0
```

and for tabline:

```vim
let g:yealine_tab_separators = g:yealine_separators
let g:yealine_tab_separator_inverse = 0
```

The first character/string from `g:yealine_separators` is used for left boxes and
second one is used for right boxes. If you want to inverse drawing set
`g:yealine_separator_inverse` to 1.

![inverse separators](https://raw.githubusercontent.com/wiki/burlog/yealine.vim/img/yealine2.png)

## Extend Yealine

The Yealine box is defined as Vim function that gets two params - `active` and
`bufno`. The `active` param is set to 1 if box is drawn in active statusline
and 0 otherwise. The second param `bufno` is set to buffer number for which is
statusline drawn.

The box function is supposted to return the pair of color defined as the Color
chapter defines and the second one is the content of the box. You can use Vim %
magic shortcuts for from statusline (:help statusline).

For example:

```vim
function! yealine#boxes#Filename(active, bufno)
    return [[0, 34], "%f"]
endfunction
```

There is some helper function that you can use in your widgets:

* `yealine#boxes#GetBufferFilename` - returns buffer filename,
* `yealine#boxes#Color` - returns color for given name from `g:yealine_colors`,
* `yealine#boxes#BaseColor` - returns base color,
* `yealine#boxes#TabColor` - return color for given name from `g:yealine_colors`,
* `yealine#boxes#TabBaseColor` - returns base color.

So you can change box to:

```vim
function! yealine#boxes#Filename(active, bufno)
    return [yealine#BaseColor(a:active), "%f"]
endfunction
```

It's simple to combine with other plugins. For example with
[YouCompleteMe](https://github.com/Valloric/YouCompleteMe) syntax diagnostic feature:

```vim
function! YeaLineYcmDiag(active, bufno)
    let filetype = getbufvar(a:bufno, "&filetype")
    if a:active && exists("g:ycm_filetype_whitelist")
        let whitelist_allows = has_key(g:ycm_filetype_whitelist, "*") || has_key(g:ycm_filetype_whitelist, &filetype)
        let blacklist_allows = !has_key(get(g:, "ycm_filetype_blacklist", {}), &filetype)
        if whitelist_allows && blacklist_allows
            let errors = youcompleteme#GetErrorCount()
            if errors
                return [[0, 160], "there is " . errors . " errors"]
            endif
            let warnings = youcompleteme#GetWarningCount()
            if warnings
                return [[0, 3], "there is " . warnings . " warnings"]
            endif
        endif
    endif
    return [yealine#BaseColor(a:active), ""]
endfunction
```

## License

The MIT License (MIT)

Copyright (c) 2016-2016 Michal Bukovsky <burlog@seznam.cz>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
