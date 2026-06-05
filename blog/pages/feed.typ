#import "index.typ": posts

#context {
  let entries = posts.map(it => {
    let c = include "../content/" + it + ".typ"
    let meta = c.children.find(it => repr(it).starts-with("metadata")).value

    let updated = if "lastmod" in meta { meta.lastmod } else { meta.date }
    (
      updated,
      "<entry><id>https://zerolimits.dev/blog/"
        + it
        + "</id><title>"
        + meta.title
        + "</title><updated>"
        + updated.display("[year]-[month]-[day]T00:00:00Z")
        + "</updated><link rel=\"alternate\" href=\"https://zerolimits.dev/blog/"
        + it
        + "\" /><published>"
        + meta.date.display("[year]-[month]-[day]T00:00:00Z")
        + "</published>"
        + "</entry>",
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

  (
    "<?xml version=\"1.0\" encoding=\"utf-8\"?><feed xmlns=\"http://www.w3.org/2005/Atom\"><id>https://zerolimits.dev/blog/</id><title>The Blog of Random</title><updated>"
      + lastmod.display("[year]-[month]-[day]T00:00:00Z")
      + "</updated><link rel=\"self\" href=\"https://zerolimits.dev/blog/feed.atom\" /><subtitle>A blog about the most random things you can think of.</subtitle><author><name>noClaps</name><uri>https://zerolimits.dev</uri></author><icon>https://zerolimits.dev/favicon.png</icon>"
      + entries
      + "</feed>"
  )
}
