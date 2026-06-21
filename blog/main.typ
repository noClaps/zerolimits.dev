#let note(title: [NOTE], body) = {
  html.div(class: "note")[
    *#title*

    #body
  ]
}

#let display-post(body) = {
  show math.equation.where(block: true): html.div
  // TODO: remove when typst mathml supports overline
  show math.overline: it => html.elem("mover", attrs: (accent: "false"), {
    it
    html.elem("mo", "_")
  })
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

  body
}

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

#for post in posts {
  context {
    let c = include "content/" + post + ".typ"
    let meta = c.children.find(it => repr(it).starts-with("metadata")).value
    document(
      "blog/" + post + ".html",
      title: meta.title,
      date: meta.date,
      context {
        html.html(lang: "en", {
          html.head({
            html.meta(charset: "utf-8")
            html.meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
            html.title(document.title)
            html.meta(name: "description", content: "A blog about the most random things you can think of.")
            html.link(rel: "alternate", href: "/blog/feed.atom", type: "application/atom+xml")
            html.link(rel: "icon", href: "/favicon.png")
            html.link(rel: "stylesheet", href: "/global.css")
            html.style(read("styles/post.css"))
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
                html.time(datetime: document.date, document.date.display())
                title()
              })
              html.article(display-post(c))
            })
          })
        })
      },
    )
  }
}

#let reserved = ("/blog/index.html", "/blog/feed.atom")
#document("blog/index.html", context {
  let files = query(document)
    .filter(it => not reserved.contains(it.path))
    .sorted(key: it => it.date, by: (l, r) => l >= r)

  html.html(lang: "en", {
    html.head({
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
      html.title[The Blog of Random]
      html.meta(name: "description", content: "A blog about the most random things you can think of.")
      html.link(rel: "alternate", href: "/blog/feed.atom", type: "application/atom+xml")
      html.link(rel: "icon", href: "/favicon.png")
      html.link(rel: "stylesheet", href: "/global.css")
      html.style(read("styles/index.css"))
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
            .map(post => html.a(href: post.path, class: "link")[
              #html.time(datetime: post.date, post.date.display())
              == #post.title
            ])
            .join(),
        )
      ]
    })
  })
})

#document("blog/feed.atom", format: "html", context {
  let entries = posts.map(it => {
    let c = include "content/" + it + ".typ"
    let meta = c.children.find(it => repr(it).starts-with("metadata")).value
    let updated = if "lastmod" in meta { meta.lastmod } else { meta.date }
    (
      updated,
      html.elem("entry", {
        html.elem("id", "https://zerolimits.dev/blog/" + it)
        html.elem("title", meta.title)
        html.elem("updated", updated.display("[year]-[month]-[day]T00:00:00Z"))
        html.elem("link", attrs: (rel: "alternate", href: "https://zerolimits.dev/blog/" + it))
        html.elem("published", meta.date.display("[year]-[month]-[day]T00:00:00Z"))
        html.elem("content", attrs: (type: "html"), display-post(c))
      }),
    )
  })

  let lastmod = datetime(year: 1970, month: 1, day: 1)
  let entry-content = ()
  for (date, content) in entries {
    if date > lastmod {
      lastmod = date
    }
    entry-content.push(content)
  }
  let entries = entry-content.join()

  html.html({
    html.head()
    html.elem("feed", attrs: (xmlns: "http://www.w3.org/2005/Atom"), {
      html.elem("id", "https://zerolimits.dev/blog/")
      html.elem("title", "The Blog of Random")
      html.elem("updated", lastmod.display("[year]-[month]-[day]T00:00:00Z"))
      html.elem("link", attrs: (rel: "self", href: "https://zerolimits.dev/blog/feed.atom"))
      html.elem("subtitle", "A blog about the most random things you can think of.")
      html.elem("author", {
        html.elem("name", "noClaps")
        html.elem("uri", "https://zerolimits.dev")
      })
      html.elem("icon", "https://zerolimits.dev/favicon.png")
      entries
    })
  })
})
