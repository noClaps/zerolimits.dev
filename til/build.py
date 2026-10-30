import subprocess
from glob import glob
from pathlib import Path


def build_entry(file):
    return subprocess.run(
        ["blackrock", file], check=True, capture_output=True, text=True
    ).stdout


main = Path("til/index.html").read_text()
files = glob("til/content/*.md")
files.sort(reverse=True)

entries = []
for file in files:
    date = file.replace("til/content/", "").replace(".md", "")
    content = build_entry(file)
    entry = "<article>"
    entry += f"<h2>{date}</h2>"
    entry += content
    entry += "</article>"
    entries.append(entry)

main = main.replace("<!--entries-->", "".join(entries))

html = Path("base.html").read_text()
html = html.replace("<!--title-->", "Today I Learned")
html = html.replace("<!--head-->", '<link rel="stylesheet" href="/til/style.css" />')
html = html.replace("<!--main-->", main)
Path("dist/til/index.html").write_text(html)
