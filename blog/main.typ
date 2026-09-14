#import "../utils.typ": minify-css

#let posts = (
  "be-social",
  "browsers",
  "chaos-theory",
  "collatz-conjecture",
  "duty-of-care",
  "floats",
  "google",
  "history-of-toilet-paper",
  "intro-psa",
  "messengers",
  "minimalism",
  "mozilla",
  "my-takes-on-ai",
  "operating-systems",
  "po-shen-loh",
  "promises",
  "quantum-and-particle",
  "random-numbers",
  "recap-2025",
  "sarajevo",
  "secton",
  "simplicity-in-software",
  "split-brain",
  "tech-stack-2023",
  "tech-stack-2024",
  "the-phalanx-formation",
  "threat-modelling",
)

#let content = posts.map(p => {
  let c = include "content/" + p + ".typ"
  let meta = c.children.find(it => repr(it).starts-with("metadata")).value
  (name: p, body: c, title: meta.title, date: meta.date, lastmod: meta.at("lastmod", default: none))
})

#for item in content {
  show math.equation.where(block: true): html.div
  // TODO: remove when typst mathml supports overline
  show math.overline: it => math.attach(math.limits(it), t: math.op[\_])
  show link: it => if type(it.dest) == str and it.dest.starts-with("https") {
    html.a(target: "_blank", rel: ("noreferrer", "noopener"), href: it.dest, it.body)
  } else {
    it
  }
  set quote(block: true, quotes: false)
  counter(figure.where(kind: image)).update(0)

  [
    #document("blog/" + item.name + ".html", {
      html.html(lang: "en", {
        // head
        html.head({
          html.meta(charset: "utf-8")
          html.meta(name: "viewport", content: "width=device-width")
          html.title(item.title)
          html.link(rel: "alternate", href: "/blog/feed.atom", type: "application/atom+xml")
          html.link(rel: "icon", href: "/favicon.png")
          html.style(minify-css(read("../homepage/global.css") + read("styles/post.css")))
        })
        // body
        html.header({
          html.h1(link("/blog/")[The Blog of Random])
          html.nav({
            link("/")[Homepage]
            link("/gallery/")[Gallery]
          })
        })
        html.main({
          html.div(class: "post-header", {
            html.time(datetime: item.date, item.date.display())
            html.h1(item.title)
          })
          html.article(item.body)
        })
      })
    })
    #label(item.name)
  ]
}

#document("blog/index.html", {
  let files = content.sorted(key: it => it.date, by: (l, r) => l >= r)

  html.html(lang: "en", {
    html.head({
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width")
      html.title[The Blog of Random]
      html.link(rel: "alternate", href: "/blog/feed.atom", type: "application/atom+xml")
      html.link(rel: "icon", href: "/favicon.png")
      html.style(minify-css(read("../homepage/global.css") + read("styles/index.css")))
    })
    // body
    html.header({
      html.h1(sym.zws)
      html.nav({
        link("/")[Homepage]
        link("/gallery/")[Gallery]
      })
    })
    html.main[
      #html.div(class: "title", {
        html.h1[The Blog of Random]
        html.p[A blog about the most random things you can think of.]
      })

      #html.section(
        files
          .map(post => html.a(href: "/blog/" + post.name + ".html", class: "link", {
            html.time(datetime: post.date, post.date.display())
            heading(level: 2, post.title)
          }))
          .join(),
      )
    ]
  })
})
