#document("cli/index.html", html.html(lang: "en", {
  html.head({
    html.meta(charset: "utf-8")
    html.meta(name: "viewport", content: "width=device-width")
    html.meta(name: "description", content: "A CLI version of ZeroLimits.dev.")
    html.style(read("./style.css"))
    html.link(rel: "icon", href: "/favicon.png")
    html.title("zerolimits --cli")
  })
  html.body({
    html.pre(id: "log", {
      html.noscript[This site requires JavaScript to work!]
    })
    html.main({
      "user@zerolimits.dev ~ >"
      html.input(type: "text", name: "prompt", autofocus: true, aria-label: "prompt")
    })
    html.script({
      "const directory = " + json.encode(json("../homepage/data.json"), pretty: false) + ";" + read("script.js")
    })
  })
}))
