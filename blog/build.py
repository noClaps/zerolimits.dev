import json
import subprocess
import sys
from glob import glob
from os import makedirs
from pathlib import Path
from shutil import copy
from tempfile import mkstemp

posts = []
for p in glob("blog/content/*.md"):
    p = p.replace(".md", "").replace("blog/content/", "")
    source = Path(f"blog/content/{p}.md").read_text()
    fd, tmp = mkstemp(suffix=".template")
    with open(fd, "w") as f:
        f.write("$meta-json$")
    pandoc_json = subprocess.run(
        ["pandoc", f"blog/content/{p}.md", f"--template={tmp}", "--to=plain"],
        capture_output=True,
        check=True,
        text=True,
    ).stdout
    fm = json.loads(pandoc_json)
    posts.append((p, fm["title"], fm["date"]))

posts.sort(key=lambda x: x[2], reverse=True)

makedirs("dist/blog/", exist_ok=True)
for p, title, post_date in posts:
    proc = subprocess.run(
        [
            "pandoc",
            f"blog/content/{p}.md",
            "--wrap=none",
            "--embed-resources",
            "--resource-path=blog/content",
            "--lua-filter=blog/filter.lua",
        ],
        capture_output=True,
        check=False,
        text=True,
    )
    if proc.returncode != 0:
        print(proc.stderr)
        sys.exit(1)
    else:
        template = Path("blog/post.html").read_text()
        html = proc.stdout
        html = template.replace("<!--body-->", html)
        html = html.replace("<!--title-->", title)
        html = html.replace("<!--date-->", post_date)

        html = html.replace("<table>", "<div><table>")
        html = html.replace("</table>", "</table></div>")

        Path(f"dist/blog/{p}.html").write_text(html)

index = Path("blog/index.html").read_text()
post_index = []
for p, title, post_date in posts:
    entry = f'<a href="/blog/{p}" class="link"><time datetime="{post_date}">{post_date}</time><h3>{title}</h3></a>'
    post_index.append(entry)
index = index.replace("<!--posts-->", "".join(post_index))
Path("dist/blog/index.html").write_text(index)

copy("blog/styles/index.css", "dist/blog/index.css")
copy("blog/styles/post.css", "dist/blog/post.css")
