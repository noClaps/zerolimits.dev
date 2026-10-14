local pandoc = pandoc
local stringify = pandoc.utils.stringify

function Meta(m)
    local entries = pandoc.MetaList({})
    for _, file in ipairs(PANDOC_STATE.input_files) do
        local slug = file:match("([^/\\]+)%.md$"):gsub("%.md$", "")

        local h = io.open(file, "r")
        if h == nil then goto continue end
        local src = h:read("a")
        h:close()
        local doc = pandoc.read(src, "markdown")
        local meta = doc.meta

        h = io.open("dist/blog/" .. slug .. ".html")
        if h == nil then goto continue end
        local html = h:read("a")
        h:close()

        -- string.find
        local _, start_idx = html:find("<article>")
        local end_idx = html:find("</article>", start_idx)
        local article = html:sub(start_idx, end_idx)

        local updated = meta.date
        if meta.lastmod ~= nil then
            updated = meta.lastmod
        end

        entries[#entries + 1] = pandoc.MetaMap({
            title = pandoc.MetaString(stringify(meta.title)),
            date = pandoc.MetaString(stringify(meta.date)),
            updated = pandoc.MetaString(stringify(updated)),
            slug = pandoc.MetaString(slug),
            article = pandoc.MetaString(article)
        })

        ::continue::
    end

    m.updated = pandoc.MetaString(os.date("!%Y-%m-%d"))
    m.entries = entries
    return m
end
