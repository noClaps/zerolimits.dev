from json import JSONDecoder
from os import makedirs
from pathlib import Path
from shutil import copy

data = JSONDecoder().decode(Path("homepage/data.json").read_text())
html = Path("homepage/index.html").read_text()

contact = ""
for value in data["contact"].values():
    contact += f'<li><strong>{value["name"]}:</strong> <a href="{value["link"]}f">{value["link-name"]}</a></li>'
html = html.replace("<!--contact-->", contact)


def project_link(project):
    out = '<div class="link">'
    if "link" in project:
        out += f'<h3><a href="{project["link"]}">{project["name"]}</a></h3>'
    else:
        out += f"<h3>{project['name']}</h3>"
    out += f'<p>{project["description"]} <a href="{project["source"]}">Source</a></p>'
    out += "</div>"
    return out


projects = ""
for project in data["projects"].values():
    projects += project_link(project)
html = html.replace("<!--projects-->", projects)

makedirs("dist/", exist_ok=True)
Path("dist/index.html").write_text(html)
copy("homepage/data.json", "dist/data.json")
copy("homepage/favicon.png", "dist/favicon.png")
copy("homepage/global.css", "dist/global.css")
copy("homepage/style.css", "dist/style.css")
