function CodeBlock(el)
    local lang = el.classes[1] or ""
    local out = pandoc.pipe("./highlighter/highlighter", { lang, el.text }, "")
    return pandoc.RawBlock("html", out)
end

function BlockQuote(el)
    local start = el.content[1]
    if (start.t == "Para" and start.content[1].t == "Str" and start.content[1].text:match("^%[!%w+%][-+]?$")) then
        local _, _, ctype = start.content[1].text:find("%[!(%w+)%]")
        start.content:remove(1)
        if start.content[1] and start.content[1].t == "Space" then
            start.content:remove(1)
        end
        if #start.content == 0 then
            start.content:insert(pandoc.Str(ctype:upper()))
        end
        local div = pandoc.Div(el.content, { class = ctype:lower() })
        return div
    else
        return el
    end
end

function Table(el)
    return pandoc.Div(el)
end
