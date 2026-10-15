function CodeBlock(el)
    local lang = el.classes[1] or ""
    local out = pandoc.pipe("./highlighter/target/release/highlighter", { lang, el.text }, "")
    return pandoc.RawBlock("html", out)
end
