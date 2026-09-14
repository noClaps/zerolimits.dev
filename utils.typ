#let minify-css(style) = {
  for match in style.matches(regex("(--\w+): ([^;]+);")) {
    style = style
      .replace(match.captures.at(0) + ": " + match.captures.at(1) + ";", "")
      .replace("var(" + match.captures.at(0) + ")", match.captures.at(1))
  }
  style
    .replace("\n", "")
    .replace(regex("\s*([{};:,])\s*"), matches => matches.captures.at(0))
    .replace(regex("/\*\s*[^\*]+\s*\*/"), "")
    .replace(regex("[^{}]+\{\}"), "")
}

#let note(title: [NOTE], body) = {
  html.div(class: "note")[
    *#title*

    #body
  ]
}
