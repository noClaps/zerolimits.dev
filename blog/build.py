import html
import json
import re
import subprocess
from concurrent.futures import ThreadPoolExecutor
from datetime import date
from glob import glob
from pathlib import Path


def get_meta(file):
    meta = subprocess.run(
        ["blackrock", "--metadata", file], check=True, capture_output=True, text=True
    ).stdout
    return json.loads(meta)


def build_post(path):
    html = subprocess.run(
        ["blackrock", path], check=True, capture_output=True, text=True
    ).stdout

    html = html.replace("<table", "<div><table")
    html = html.replace("</table>", "</table></div>")
    html = re.sub(
        r'(<math display="block".*?</math>)',
        r"<div>\1</div>",
        html,
        flags=re.DOTALL,
    )

    return html


def process(file):
    meta = get_meta(file)
    meta["title"] = file.replace("blog/content/", "").replace(".md", "")
    meta["path"] = file
    meta["content"] = build_post(file)
    return meta


with ThreadPoolExecutor() as pool:
    metadata = list(pool.map(process, glob("blog/content/*.md")))
metadata.sort(key=lambda x: x["date"], reverse=True)

# index
index = Path("blog/index.html").read_text()
posts = []
for m in metadata:
    post = f'<a href="/blog/{m["slug"]}" class="link">'
    post += f'<time datetime="{m["date"]}">{m["date"]}</time>'
    post += f"<h3>{m['title']}</h3>"
    post += "</a>"
    posts.append(post)
index = index.replace("<!--posts-->", "".join(posts))

base_html = Path("base.html").read_text()
base_html = base_html.replace("<!--title-->", "The Blog of Random")
base_html = base_html.replace(
    "<!--head-->",
    """<link rel="alternate" href="/blog/feed.atom" type="application/atom+xml" />
<link rel="stylesheet" href="/blog/index.css" />""",
)
base_html = base_html.replace("<!--main-->", index)
Path("dist/blog/index.html").write_text(base_html)

# posts
base_html = Path("base.html").read_text()
post_templ = Path("blog/post.html").read_text()
for i, m in enumerate(metadata):
    post = post_templ.replace("<!--title-->", m["title"])
    post = post.replace("<!--date-->", m["date"])
    post = post.replace("<!--content-->", m["content"])

    base_html = base_html.replace("<!--title-->", m["title"])
    base_html = base_html.replace(
        "<!--head-->",
        """
        <link rel="alternate" href="/blog/feed.atom" type="application/atom+xml" />
        <link rel="stylesheet" href="/blog/post.css" />
        """,
    )
    base_html = base_html.replace("<!--main-->", post)
    Path(f"dist/blog/{m['slug']}.html").write_text(base_html)

# feed
feed = Path("blog/feed.atom").read_text()
feed = feed.replace("<!--updated-->", date.today().isoformat())
entries = []
for m in metadata:
    entry = "<entry>"
    entry += f"<id>https://zerolimits.dev/blog/{m['slug']}</id>"
    entry += f"<title>{m['title']}</title>"
    if "lastmod" in m:
        entry += f"<updated>{m['lastmod']}T00:00:00Z</updated>"
    else:
        entry += f"<updated>{m['date']}T00:00:00Z</updated>"
    entry += f'<link rel="alternate" href="https://zerolimits.dev/blog/{m["slug"]}" />'
    entry += f"<published>{m['date']}T00:00:00Z</published>"
    entry += f'<content type="html">{html.escape(m["content"])}</content>'
    entry += "</entry>"
    entries.append(entry)
feed = feed.replace("<!--entries-->", "".join(entries))
Path("dist/blog/feed.atom").write_text(feed)
