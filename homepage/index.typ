#let project-link(title, description: [], source: "") = {
  html.div(class: "link", {
    html.h3(title)
    [#description #link(source)[Source]]
  })
}

#{
  html.html(lang: "en", {
    html.head({
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
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

          - *Email:* #link("mailto:contact@zerolimits.dev")
          - *GitHub:* #link("https://github.com/noClaps")[noClaps]
        ])

        = Projects

        #html.section({
          project-link(
            [Cite],
            description: [A tool to generate Hayagriva citations from DOI URLs.],
            source: "https://github.com/noClaps/cite",
          )
          project-link(
            link("https://nc.klado.dev")[NC],
            description: [A new programming language that I'm working on.],
            source: "https://arbor.klado.dev/nclang",
          )
          project-link(
            [QCSim],
            description: [A quantum computer simulation research project.],
            source: "https://github.com/noClaps/qcsim",
          )
          project-link(
            link("https://zerolimits.dev")[ZeroLimits.dev],
            description: [A site about the most interesting boring person you've ever met.],
            source: "https://github.com/noClaps/zerolimits.dev",
          )
        })
      ]
    })
  })
}
