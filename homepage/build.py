import json
from pathlib import Path

data = json.loads(Path("homepage/data.json").read_text())
html = Path("homepage/index.html").read_text()

contact = ""
for value in data["contact"].values():
    contact += f'<li><strong>{value["name"]}:</strong> <a href="{value["link"]}f">{value["link-name"]}</a></li>'
html = html.replace("<!--contact-->", contact)


def project_link(project):
    out = '<div class="link">'
    if "link" in project:
        out += f'<h3><a href="{project["link"]}">{project["name"]}</a>'
    else:
        out += f"<h3>{project['name']}"

    out += f'<a href="{project["source"]}" title="Source code" class="code">{Path("homepage/icons/code.svg").read_text()}</a>'
    out += "</h3>"
    out += f"<p>{project['description']}</p>"
    if "languages" in project:
        out += "<span>"
        for lang in project["languages"]:
            out += Path(f"homepage/icons/{lang}.svg").read_text()
        out += "</span>"
    out += "</div>"
    return out


projects = ""
for project in data["projects"].values():
    projects += project_link(project)
html = html.replace("<!--projects-->", projects)

Path("dist/index.html").write_text(html)
