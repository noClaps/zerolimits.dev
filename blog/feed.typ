#import "main.typ": posts

#let escape(str) = {
  str.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&apos;")
}

#let entries = posts.map(it => {
  let c = include "content/" + it + ".typ"
  let meta = c.children.find(it => repr(it).starts-with("metadata")).value

  let content = read("../dist/blog/" + it + ".html")
  let article = content.slice(content.position("<article>") + "<article>".len(), content.position("</article>"))
  let title = content.slice(content.position("<title>") + "<title>".len(), content.position("</title>"))

  let updated = if "lastmod" in meta { meta.lastmod } else { meta.date }
  (
    "<entry><id>https://zerolimits.dev/blog/"
      + it
      + "</id><title>"
      + title
      + "</title><updated>"
      + updated.display("[year]-[month]-[day]T00:00:00Z")
      + "</updated><link rel=\"alternate\" href=\"https://zerolimits.dev/blog/"
      + it
      + "\" /><published>"
      + meta.date.display("[year]-[month]-[day]T00:00:00Z")
      + "</published><content type=\"html\">"
      + escape(article)
      + "</content></entry>"
  )
})

#asset(
  "blog/feed.atom",
  "<?xml version=\"1.0\" encoding=\"utf-8\"?><feed xmlns=\"http://www.w3.org/2005/Atom\"><id>https://zerolimits.dev/blog/</id><title>The Blog of Random</title><updated>"
    + datetime.today().display("[year]-[month]-[day]T00:00:00Z")
    + "</updated><link rel=\"self\" href=\"https://zerolimits.dev/blog/feed.atom\" /><subtitle>A blog about the most random things you can think of.</subtitle><author><name>noClaps</name><uri>https://zerolimits.dev</uri></author><icon>https://zerolimits.dev/favicon.png</icon>"
    + entries.join()
    + "</feed>",
)
