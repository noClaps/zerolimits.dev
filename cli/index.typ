#document("cli/index.html", html.html({
  // head
  html.meta(charset: "utf-8")
  html.meta(name: "viewport", content: "width=device-width")
  html.style(read("./style.css"))
  html.link(rel: "icon", href: "/favicon.png")
  html.title("zerolimits --cli")

  // body
  html.pre(id: "log", {
    [ZeroLimits.dev #sym.dash.em Made by #link("/")[noClaps]]
    "
Commands:
  clear                    Clear the screen
  ls [directory] [--keys]  List contents of directory
  open <key> [--source]    Open link or source in a new tab
"
    html.noscript[This site requires JavaScript to work!]
  })
  html.main({
    "user@zerolimits.dev / >"
    html.input(type: "text", name: "prompt", autofocus: true, aria-label: "prompt")
  })
  html.script(
    "const directory = " + json.encode(json("../homepage/data.json"), pretty: false) + ";" + read("script.js"),
  )
}))
