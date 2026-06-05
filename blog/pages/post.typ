#let post(body) = context {
  show math.equation: it => box(html.frame(it))
  show math.equation.where(block: true): it => block(html.frame(it))

  show link: it => {
    if type(it.dest) == str and it.dest.starts-with("https") {
      html.a(target: "_blank", rel: ("noreferrer", "noopener"), href: it.dest, it.body)
    } else {
      it
    }
  }
  show heading: it => {
    html.elem(
      "h" + repr(it.level + 1),
      attrs: (id: lower(repr(it.body).slice(1, -1)).replace(regex("[^\w]"), "-")),
      it.body,
    )
  }

  set quote(block: true, quotes: false)

  let metadata = query(metadata).first().value
  let title = metadata.title
  let date = metadata.date

  html.html(lang: "en", {
    html.head({
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
      html.title(title)
      html.meta(name: "description", content: "A blog about the most random things you can think of.")
      html.link(rel: "alternate", href: "/blog/feed.atom", type: "application/atom+xml")
      html.link(rel: "icon", href: "/favicon.png")
      html.link(rel: "stylesheet", href: "/global.css")
      html.style(read("../styles/post.css"))
    })
    html.body({
      html.header({
        html.h1(link("/blog/")[The Blog of Random])
        html.nav({
          link("/")[Homepage]
          link("/gallery/")[Gallery]
        })
      })
      html.main({
        html.div(class: "post-header", {
          html.time(datetime: date, date.display())
          html.h1(title)
        })
        html.article(body)
      })
    })
  })
}

#let note(title: [NOTE], body) = {
  html.div(class: "note")[
    *#title*

    #body
  ]
}
