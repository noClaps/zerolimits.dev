function Meta(m)
    local posts = {}
    for _, file in ipairs(PANDOC_STATE.input_files) do
        local h = io.open(file, "r")
        if h == nil then goto continue end
        local src = h:read("a")
        h:close()

        local doc = pandoc.read(src, "markdown")
        local meta = doc.meta
        local slug = file:match("([^/\\]+)%.md$"):gsub("%.md$", "")

        table.insert(posts, {
            title = meta.title,
            date = pandoc.utils.stringify(meta.date),
            url = "/blog/" .. slug,
        })

        ::continue::
    end

    table.sort(posts, function(a, b) return a.date > b.date end)

    local list = {}
    for _, p in ipairs(posts) do
        table.insert(list, {
            title = p.title,
            date = p.date,
            url = p.url
        })
    end

    m.posts = list
    return m
end
