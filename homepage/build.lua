local function get_icon(name)
    local f = io.open("homepage/icons/" .. name .. ".svg")
    if not f then return "" end
    local icon = f:read("a")
    f:close()
    return icon
end

function Meta(m)
    local f = io.open("homepage/data.json", "r")
    if not f then return m end
    local json = f:read("a")
    f:close()

    local data = pandoc.json.decode(json)

    local contact = {}
    for k, v in pairs(data.contact) do
        contact[#contact + 1] = {
            key = k,
            name = v.name,
            link = v.link,
            link_name = v["link-name"]
        }
    end
    table.sort(contact, function(a, b) return a.key < b.key end)

    local projects = {}
    for k, v in pairs(data.projects) do
        local langs = {}
        if v.languages ~= nil then
            for _, lang in ipairs(v.languages) do
                table.insert(langs, pandoc.RawInline("html", get_icon(lang)))
            end
        end

        table.insert(projects, {
            key = k,
            name = v.name,
            link = v.link or "",
            description = v.description,
            languages = langs
        })
    end
    table.sort(projects, function(a, b) return a.key < b.key end)

    m.contact = contact
    m.projects = projects
    return m
end
