#let note(title: [NOTE], body) = {
  html.div(class: "note")[
    *#title*

    #body
  ]
}

#let post(title: [], date: datetime, lastmod: none, body) = {
  show math.equation.where(block: true): html.div
  // TODO: remove when typst mathml supports overline
  show math.overline: it => math.attach(math.limits(it), t: math.op[\_])
  show link: it => if type(it.dest) == str and it.dest.starts-with("https") {
    html.a(target: "_blank", rel: ("noreferrer", "noopener"), href: it.dest, it.body)
  } else {
    it
  }
  show table: html.div
  set quote(block: true, quotes: false)
  counter(figure.where(kind: image)).update(0)

  html.html(lang: "en", {
    html.head({
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width")
      html.title(title)
      html.link(rel: "alternate", href: "/blog/feed.atom", type: "application/atom+xml")
      html.link(rel: "icon", href: "/favicon.png")
      html.link(rel: "stylesheet", href: "/global.css")
      html.link(rel: "stylesheet", href: "/blog/post.css")
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
