#import "../utils.typ": minify-css

#let project-link(project) = {
  html.div(class: "link")[
    == #if project.keys().contains("link") { link(project.link, project.name) } else { project.name }
    #project.description  #link(project.source)[Source]
  ]
}

#asset("favicon.png", read("favicon.png", encoding: none))
#document("index.html", {
  let data = json("data.json")
  html.html(lang: "en", {
    // head
    html.meta(charset: "utf-8")
    html.meta(name: "viewport", content: "width=device-width")
    html.link(rel: "alternate", href: "/blog/feed.atom", type: "application/atom+xml")
    html.link(rel: "icon", href: "/favicon.png")
    html.style(minify-css(read("./global.css") + read("./style.css")))
    html.title[ZeroLimits.dev]
    // body
    html.header({
      html.h1(sym.zws)
      html.nav({
        link("/blog/")[Blog]
        link("/gallery/")[Gallery]
      })
    })
    html.main({
      html.div(class: "title", {
        html.h1[ZeroLimits.dev]

        [The most interesting boring person you've ever met.]

        for value in data.contact.values() [
          - *#value.name:* #link(value.link, value.link-name)
        ]
      })

      heading[Projects]

      html.section({
        for project in data.projects.values() {
          project-link(project)
        }
      })
    })
    html.footer({
      link("https://codeberg.org/noClaps/zerolimits.dev")[Source]
      link("/cli")
    })
  })
})
