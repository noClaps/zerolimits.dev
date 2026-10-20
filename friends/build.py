from pathlib import Path

main = Path("friends/index.html").read_text()

html = Path("base.html").read_text()
html = html.replace("<!--title-->", "Friends")
html = html.replace(
    "<!--head-->", '<link rel="stylesheet" href="/friends/style.css" />'
)
html = html.replace("<!--main-->", main)
Path("dist/friends/index.html").write_text(html)
