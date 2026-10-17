import json
from pathlib import Path

html = Path("homepage/index.html").read_text()
data = json.loads(Path("homepage/data.json").read_text())

contacts = [
    f'<li><strong>{c["name"]}:</strong> <a href="{c["link"]}">{c["link-name"]}</a>'
    for c in data["contact"].values()
]
html = html.replace("<!--contact-->", "".join(contacts))

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

html = html.replace("<!--projects-->", "".join(projects))

Path("dist/index.html").write_text(html)
