local stringify = pandoc.utils.stringify

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
            title = stringify(meta.title),
            date = stringify(meta.date),
            url = "/blog/" .. slug,
        })

        ::continue::
    end

    table.sort(posts, function(a, b) return a.date > b.date end)

    local list = pandoc.MetaList({})
    for _, p in ipairs(posts) do
        list[#list + 1] = pandoc.MetaMap({
            title = pandoc.MetaString(p.title),
            date = pandoc.MetaString(p.date),
            url = pandoc.MetaString(p.url)
        })
    end

    m.posts = list
    return m
end
