import json
from pathlib import Path

main = Path("homepage/index.html").read_text()
data = json.loads(Path("homepage/data.json").read_text())

contacts = [
    f'<li><strong>{c["name"]}:</strong> <a href="{c["link"]}">{c["link-name"]}</a>'
    for c in data["contact"].values()
]
main = main.replace("<!--contact-->", "".join(contacts))

projects = []
for p in data["projects"].values():
    project = '<div class="link">'
    project += "<h3>"
    if "link" in p:
        project += f'<a href="{p["link"]}">{p["name"]}</a>'
    else:
        project += p["name"]
    project += f'<a href="{p["source"]}" title="Source code" class="code">{Path("homepage/icons/code.svg").read_text()}</a>'
    project += "</h3>"
    project += f"<p>{p['description']}</p>"
    if "languages" in p:
        project += "<span>"
        for lang in p["languages"]:
            project += Path("homepage/icons/" + lang + ".svg").read_text()
        project += "</span>"
    project += "</div>"
    projects.append(project)

main = main.replace("<!--projects-->", "".join(projects))

html = Path("base.html").read_text()
html = html.replace("<!--title-->", "ZeroLimits")
html = html.replace(
    "<!--head-->",
    """
<link rel="alternate" href="/blog/feed.atom" type="application/atom+xml" />
<link rel="stylesheet" href="/style.css" />
""",
)
html = html.replace("<!--main-->", main)
Path("dist/index.html").write_text(html)
