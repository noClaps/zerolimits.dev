import subprocess
import sys
from glob import glob
from pathlib import Path


def pandoc(file):
    try:
        return subprocess.run(
            ["pandoc", "--lua-filter=til/filter.lua", file],
            check=True,
            capture_output=True,
            text=True,
        ).stdout
    except subprocess.CalledProcessError as err:
        print(err)
        sys.exit(1)


html = Path("til/index.html").read_text()
files = glob("til/content/*.md")
files.sort(reverse=True)

entries = []
for file in files:
    date = file.replace("til/content/", "").replace(".md", "")
    content = pandoc(file)
    entry = "<article>"
    entry += f"<h2>{date}</h2>"
    entry += content
    entry += "</article>"
    entries.append(entry)

html = html.replace("<!--entries-->", "".join(entries))
Path("dist/til/index.html").write_text(html)
