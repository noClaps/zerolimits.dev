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

#context {
  let files = (
    posts
      .map(it => {
        let c = include "../content/" + it + ".typ"
        let meta = c.children.find(it => repr(it).starts-with("metadata")).value
        (slug: "blog/" + it, title: meta.title, date: meta.date)
      })
      .sorted(key: it => it.date, by: (l, r) => l >= r)
  )

  html.html(lang: "en", {
    html.head({
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
      html.title[The Blog of Random]
      html.meta(name: "description", content: "A blog about the most random things you can think of.")
      html.link(rel: "alternate", href: "/blog/feed.atom", type: "application/atom+xml")
      html.link(rel: "icon", href: "/favicon.png")
      html.link(rel: "stylesheet", href: "/global.css")
      html.style(read("../styles/index.css"))
    })
    html.body({
      html.header({
        html.h1(sym.zws)
        html.nav({
          link("/")[Homepage]
          link("/gallery/")[Gallery]
        })
      })
      html.main[
        #html.div(class: "title")[
          #html.h1[The Blog of Random]

          A blog about the most random things you can think of.
        ]

        #html.section(
          files
            .map(post => html.a(href: "/" + post.slug, class: "link")[
              #html.time(datetime: post.date, post.date.display())
              == #post.title
            ])
            .join(),
        )
      ]
    })
  })
}
