import json
import subprocess
import sys
from datetime import date
from glob import glob
from pathlib import Path
from tempfile import mkstemp


def get_meta(file):
    _, tmp = mkstemp(".template")
    Path(tmp).write_text("$meta-json$")
    try:
        meta = subprocess.run(
            ["pandoc", "--wrap=none", "--template", tmp, file],
            check=True,
            capture_output=True,
            text=True,
        ).stdout
        return json.loads(meta)
    except subprocess.CalledProcessError as err:
        print(err)
        sys.exit(1)


def build_post(path):
    try:
        return subprocess.run(
            [
                "pandoc",
                "--lua-filter=blog/post.lua",
                "--embed-resources",
                f"--resource-path={':'.join(glob('blog/content/assets/*'))}",
                "--wrap=none",
                path,
            ],
            check=True,
            capture_output=True,
            text=True,
        ).stdout
    except subprocess.CalledProcessError as err:
        print(err)
        sys.exit(1)


metadata = []
for file in glob("blog/content/*.md"):
    meta = get_meta(file)
    meta["title"] = file.replace("blog/content/", "").replace(".md", "")
    meta["path"] = file
    metadata.append(meta)
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
index = index.replace("<!--gallery.svg-->", Path("icons/gallery.svg").read_text())
index = index.replace("<!--til.svg-->", Path("icons/til.svg").read_text())
Path("dist/blog/index.html").write_text(index)

# posts
post_templ = Path("blog/post.html").read_text()
for i, m in enumerate(metadata):
    post = post_templ.replace("<!--title-->", m["title"])
    post = post.replace("<!--date-->", m["date"])
    content = build_post(m["path"])
    metadata[i]["content"] = content
    post = post.replace("<!--content-->", content)
    post = post.replace("<!--homepage.svg-->", Path("icons/homepage.svg").read_text())
    post = post.replace("<!--gallery.svg-->", Path("icons/gallery.svg").read_text())
    post = post.replace("<!--til.svg-->", Path("icons/til.svg").read_text())
    Path(f"dist/blog/{m['slug']}.html").write_text(post)

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
    entry += f'<content type="html">{m["content"]}</content>'
    entry += "</entry>"
    entries.append(entry)
feed = feed.replace("<!--entries-->", "".join(entries))
Path("dist/blog/feed.atom").write_text(feed)
