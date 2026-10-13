import json
import subprocess
from glob import glob
from pathlib import Path
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

index = Path("blog/index.html").read_text()
post_index = []
for p, title, post_date in posts:
    entry = f'<a href="/blog/{p}" class="link"><time datetime="{post_date}">{post_date}</time><h3>{title}</h3></a>'
    post_index.append(entry)
index = index.replace("<!--posts-->", "".join(post_index))
Path("dist/blog/index.html").write_text(index)
