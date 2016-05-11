" yaline.vim - Yet Another Vim Status Line
" Maintainer:   Michal Bukovsky <burlog@seznam.cz>
" Licence:      MIT

function! yealine#boxes#Color(active, name)
    let spec = yealine#MapConfGet("yealine_colors", a:name, yealine#BaseColor(a:active))
    if type(spec[0]) == type([])
        return spec[a:active]
    endif
    return spec
endfunction

function! yealine#boxes#TabColor(name)
    return yealine#MapConfGet("yealine_colors", a:name, yealine#TabBaseColor())
endfunction

function! yealine#boxes#Buffer(active, bufno)
    return [yealine#boxes#Color(a:active, "Buffer"), (bufnr("$") > 9)? "%2.2n": "%n"]
endfunction

function! yealine#boxes#Mode(active, bufno)
    if a:active
        return yealine#MapConfGet("yealine_mode_map", mode(), [yealine#BaseColor(a:active), "UNKNOWN"])
    endif
    return [yealine#BaseColor(0), "HIDDEN "]
endfunction

function! yealine#boxes#Readonly(active, bufno)
    if getbufvar(a:bufno, "&readonly") && getbufvar(a:bufno, "&filetype") != "help"
        return [yealine#boxes#Color(a:active, "Readonly"), "RO"]
    endif
    return [yealine#BaseColor(a:active), ""]
endfunction

function! yealine#boxes#Modified(active, bufno)
    if getbufvar(a:bufno, "&modified")
        if getbufvar(a:bufno, "&readonly")
            return [yealine#boxes#Color(a:active, "Readonly"), "+"]
        endif
        return [yealine#boxes#Color(a:active, "Modified"), "+"]
    endif
    return [yealine#BaseColor(a:active), ""]
endfunction

function! yealine#boxes#Filename(active, bufno)
    return [yealine#BaseColor(a:active), "%f"]
endfunction

function! yealine#boxes#Syntax(active, bufno)
    let l = 0
    for i in range(1, bufnr('$') + 1)
        let l = max([l, len(getbufvar(i, "&l:syntax"))])
    endfor
    if getbufvar(a:bufno, "&l:syntax") != ""
        return [yealine#boxes#Color(a:active, "Syntax"), "%-" . l . "." . l ."Y"]
    endif
    return [yealine#BaseColor(a:active), ""]
endfunction

function! yealine#boxes#CurrentChar(active, bufno)
    return [yealine#boxes#Mode(a:active, a:bufno)[0], "[%3.3b]"]
endfunction

function! yealine#boxes#Position(active, bufno)
    return [yealine#boxes#Color(a:active, "Position"), "column: %2.3v, line: %3.5l, total: %5.5L"]
endfunction

function! yealine#boxes#Paste(active, bufno)
    if getbufvar(a:bufno, "&paste")
        return [a:active? yealine#boxes#TabColor("Paste"): yealine#BaseColor(0), "PASTE"]
    endif
    return [yealine#BaseColor(0), ""]
endfunction

function! yealine#boxes#TabEntry()
    let i = 0
    let l:tabs = []
    let current = tabpagenr()
    let colors = yealine#boxes#TabColor("TabEntry")
    for tab in range(1, tabpagenr('$'))
        let name = bufname(tabpagebuflist(tab)[tabpagewinnr(tab) - 1])
        let content = tab . " " . ((name != "")? name : "[No name]")
        if tab == current
            let color = yealine#boxes#TabColor("TabEntryCurrent")
        else
            let color = type(colors[0]) == type([])? colors[i % len(colors)]: colors
            let i += 1
        endif
        call add(l:tabs, [color, content])
    endfor
    return [[], l:tabs]
endfunction

function! yealine#boxes#TabClose()
    return [yealine#boxes#TabColor("TabClose"), "%X× "]
endfunction

