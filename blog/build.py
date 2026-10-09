import re
import subprocess
from datetime import date
from glob import glob
from os import makedirs
from pathlib import Path
from shutil import copy

posts = []
for p in glob("blog/content/*.typ"):
    p = p.replace(".typ", "").replace("blog/content/", "")
    source = Path(f"blog/content/{p}.typ").read_text()
    title = re.search(r"title: \[([^\]]+)\]", source)
    post_date = re.search(
        r"date: datetime\(year: (\d+), month: (\d+), day: (\d+)\)", source
    )
    if title is None or post_date is None:
        continue
    title = title[1]
    post_date = date(int(post_date[1]), int(post_date[2]), int(post_date[3]))
    posts.append((p, title, post_date))

posts.sort(key=lambda x: x[2], reverse=True)

makedirs("dist/blog/", exist_ok=True)
for p, _, _ in posts:
    out = subprocess.run(
        [
            "typst",
            "compile",
            f"blog/content/{p}.typ",
            "-",
            "--format=html",
            "--features=html",
            "--root=blog",
        ],
        capture_output=True,
        check=False,
    )
    if out.returncode != 0:
        print(out.stderr.decode())
    else:
        print(out.stderr.decode())
        html = out.stdout.decode()
        headings = {}
        for match in re.finditer(r"<h(\d)>([^<]+)</h(\d)>", html):
            slug = match[2].lower()
            slug = re.sub("[^a-zA-Z0-9]+", "-", slug)
            slug = slug.strip("-")
            if slug in headings:
                html = html.replace(
                    match[0],
                    f'<h{match[1]} id="{slug}-{headings[slug]}f">{match[2]}</h{match[1]}>',
                )
                headings[slug] += 1
            else:
                headings[slug] = 1
                html = html.replace(
                    match[0],
                    f'<h{match[1]} id="{re.sub("[^a-zA-Z0-9]", "-", slug)}">{match[2]}</h{match[1]}>',
                )
        Path(f"dist/blog/{p}.html").write_text(html)

index = Path("blog/index.html").read_text()
post_index = []
for p, title, post_date in posts:
    entry = f'<a href="/blog/{p}" class="link"><time datetime="{post_date.isoformat}">{post_date.isoformat()}</time><h3>{title}</h3></a>'
    post_index.append(entry)
index = index.replace("<!--posts-->", "".join(post_index))
Path("dist/blog/index.html").write_text(index)

copy("blog/styles/index.css", "dist/blog/index.css")
copy("blog/styles/post.css", "dist/blog/post.css")
