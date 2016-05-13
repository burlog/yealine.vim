" yaline.vim - Yet Another Vim Status Line
" Maintainer:   Michal Bukovsky <burlog@seznam.cz>
" Licence:      MIT

function! yealine#ConfGet(name, ...)
    return get(g:, a:name, get(g:, "_" . a:name, get(a:, "1")))
endfunction

function! yealine#MapConfGet(name, value_name, ...)
    let user_values = get(g:, a:name, {})
    let default_values = get(g:, "_" . a:name)
    return get(user_values, a:value_name, get(default_values, a:value_name))
endfunction

function! yealine#BaseColor(active)
    return a:active? yealine#MapConfGet("yealine_colors", "BaseCurrent"): yealine#MapConfGet("yealine_colors", "Base")
endfunction

function! yealine#TabBaseColor()
    return yealine#MapConfGet("yealine_colors", "TabBase")
endfunction

function! yealine#YeaLine(bufno)
    let active = a:bufno == bufnr("%")
    if index(yealine#ConfGet("yealine_ignored_special", []), getbufvar(a:bufno, "&buftype")) != -1
        let color = call("s:make_color", yealine#BaseColor(active))
        return s:make_box([], color, "%f", "", 0, 0)
    endif
    let params = [active, a:bufno]
    let sep = yealine#ConfGet("yealine_separators")
    let inv = yealine#ConfGet("yealine_separator_inverse")
    let [prev_color, left] = yealine#DrawBoxes(yealine#ConfGet("yealine_left_boxes"), [], params, sep, inv, 0)
    let color = call("s:make_color", yealine#BaseColor(active))
    let middle = s:make_box(prev_color, color, "%=", sep, inv, 0)
    let [prev_color, right] = yealine#DrawBoxes(yealine#ConfGet("yealine_right_boxes"), color, params, sep, inv, 1)
    return left . middle . right
endfunction

function! yealine#YeaTabLine()
    let params = []
    let sep = yealine#ConfGet("yealine_tab_separators")
    let inv = yealine#ConfGet("yealine_tab_separator_inverse")
    let [prev_color, left] = yealine#DrawBoxes(yealine#ConfGet("yealine_tab_left_boxes"), [], params, sep, inv, 0)
    let color = call("s:make_color", yealine#TabBaseColor())
    let middle = s:make_box(prev_color, color, "%=", sep, inv, 0)
    let [prev_color, right] = yealine#DrawBoxes(yealine#ConfGet("yealine_tab_right_boxes"), color, params, sep, inv, 1)
    return left . middle . right
endfunction

function! yealine#DrawBoxes(boxes, prev_color, params, sep, inv, right)
    let line = ""
    let l:prev_color = a:prev_color
    for box in a:boxes
        let [box_color_spec, content] = call(box, a:params)
        if type(content) == type([])
            for [box_color_spec, inner_content] in content
                let box_color = call("s:make_color", box_color_spec)
                let line .= s:make_box(l:prev_color, box_color, inner_content, a:sep, a:inv, a:right)
                let l:prev_color = box_color
            endfor
        elseif content != ""
            let box_color = call("s:make_color", box_color_spec)
            let line .= s:make_box(l:prev_color, box_color, content, a:sep, a:inv, a:right)
            let l:prev_color = box_color
        endif
    endfor 
    return [l:prev_color, line]
endfunction

function! s:make_box(prev_color, box_color, content, sep, inv, right)
    let arrow = ""
    if a:prev_color != [] && a:prev_color != a:box_color
        if xor(a:right, a:inv)
            let [ctermfg, guifg] = [a:box_color[2], a:box_color[4]]
            let [ctermbg, guibg] = [a:prev_color[2], a:prev_color[4]]
        else
            let [ctermfg, guifg] = [a:prev_color[2], a:prev_color[4]]
            let [ctermbg, guibg] = [a:box_color[2], a:box_color[4]]
        endif
        let highlight_name = s:make_color(ctermfg, ctermbg, guifg, guibg)[0]
        let arrow .= " %#" . highlight_name . "#" . a:sep[a:inv? !a:right : a:right]
    endif
    return arrow . "%#" . a:box_color[0] . "# " . a:content
endfunction

function! s:make_color(...)
    let mode = []
    let ctermfg = a:1
    let ctermbg = a:2
    if a:0 == 3
        let guifg = ctermfg
        let guibg = ctermbg
        let mode = a:3
    elseif a:0 == 4
        let guifg = a:3
        let guibg = a:4
    elseif a:0 == 5
        let guifg = a:3
        let guibg = a:4
        let mode = a:5
    else
        let guifg = ctermfg
        let guibg = ctermbg
    endif
    return s:register_color([ctermfg, ctermbg, guifg, guibg, mode])
endfunction

function! s:register_color(color_spec)
    " TODO(burlog): mode
    let color_name = s:make_color_name(a:color_spec)
    if !hlexists(color_name)
        execute printf("highlight! %s ctermfg=%s ctermbg=%s guifg=%s guibg=%s", color_name, a:color_spec[0], a:color_spec[1], a:color_spec[2], a:color_spec[3])
    endif
    return [color_name] + a:color_spec
endfunction

function! s:make_color_name(color_spec)
    return printf("YeaLine_ctermfg_%s_ctermbg_%s_guifg_%s_guibg_%s", a:color_spec[0], a:color_spec[1], a:color_spec[2], a:color_spec[3])
endfunction

