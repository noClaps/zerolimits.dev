import json
import subprocess
from datetime import datetime, timezone
from glob import glob
from html import escape
from os import makedirs
from pathlib import Path
from tempfile import mkstemp

posts = [
    p.replace(".md", "").replace("blog/content/", "") for p in glob("blog/content/*.md")
]

entries = []
for post in posts:
    source_lines = Path(f"blog/content/{post}.md").read_text().splitlines()
    fd, tmp = mkstemp(suffix=".template")
    with open(fd, "w") as f:
        f.write("$meta-json$")
    pandoc_json = subprocess.run(
        ["pandoc", f"blog/content/{post}.md", f"--template={tmp}", "--to=plain"],
        capture_output=True,
        check=True,
        text=True,
    ).stdout
    fm = json.loads(pandoc_json)
    lastmod = fm.get("lastmod")
    title = fm["title"]

    content = Path("dist/blog/" + post + ".html").read_text()
    article = content[
        content.find("<article>") + len("<article>") : content.find("</article>")
    ]
    updated = lastmod if lastmod is not None else fm["date"]

    entry = "<entry>"
    entry += f"<id>https://zerolimits.dev/blog/{post}</id>"
    entry += f"<title>{title}</title>"
    entry += f"<updated>{updated}T00:00:00Z</updated>"
    entry += f'<link rel="alternate" href="https://zerolimits.dev/blog/{post}" />'
    entry += f"<published>{fm['date']}T00:00:00Z</published>"
    entry += f'<content type="html">{escape(article)}</content>'
    entry += "</entry>"
    entries.append(entry)

feed = Path("blog/feed.atom").read_text()
feed = feed.replace(
    "<!--updated-->", f"{datetime.now(tz=timezone.utc).date().isoformat()}T00:00:00Z"
)
feed = feed.replace("<!--entries-->", "".join(entries))
makedirs("dist/blog/", exist_ok=True)
Path("dist/blog/feed.atom").write_text(feed)
