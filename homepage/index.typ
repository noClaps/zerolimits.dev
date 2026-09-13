#let project-link(title, description: [], source: "") = {
  html.div(class: "link", {
    html.h3(title)
    html.p({
      description
      link(source)[Source]
    })
  })
}

#asset("global.css", read("global.css"))
#asset("favicon.png", read("favicon.png", encoding: none))
#document("index.html", context {
  let data = json("data.json")
  html.html(lang: "en", {
    html.head({
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width")
      html.meta(name: "description", content: "The most interesting boring person you've ever met.")
      html.link(rel: "alternate", href: "/blog/feed.atom", type: "application/atom+xml")
      html.link(rel: "icon", href: "/favicon.png")
      html.link(rel: "stylesheet", href: "/global.css")
      html.style(read("./style.css"))
      html.title[ZeroLimits.dev]
    })
    html.body({
      html.header({
        html.h1(sym.zws)
        html.nav({
          link("/blog/")[Blog]
          link("/gallery/")[Gallery]
        })
      })
      html.main[
        #html.div(class: "title", [
          #html.h1[ZeroLimits.dev]

          The most interesting boring person you've ever met.

          #for value in data.contact.values() [
            - *#value.name:* #link(value.link, value.link-name)
          ]
        ])

        = Projects

        #html.section({
          for project in data.projects.values() {
            project-link(
              if project.keys().contains("link") { link(project.link, project.name) } else { project.name },
              description: project.description,
              source: project.source,
            )
          }
        })
      ]
    })
  })
})
