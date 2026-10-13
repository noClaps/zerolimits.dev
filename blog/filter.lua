function CodeBlock(el)
    local lang = el.classes[1] or ""
    local out = pandoc.pipe("./blog/helper/target/release/helper", { lang, el.text }, "")
    return pandoc.RawBlock("html", out)
end
