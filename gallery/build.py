# sips -s format avif --resampleWidth 800 -o $out $in

import re
from pathlib import Path

html = Path("gallery/index.html").read_text()

for match in re.finditer(r'<img\s+(src="([^"]+)")', html):
    img = Path("gallery/assets/" + match[2]).read_bytes()
    ispe = img.find(b"ispe")
    width = int.from_bytes(img[ispe + 8 : ispe + 12], "big")
    height = int.from_bytes(img[ispe + 12 : ispe + 16], "big")
    html = html.replace(match[1], f'width="{width}" height="{height}" {match[1]}')
    html = html.replace(match[2], "/gallery/" + match[2])

html = html.replace("<!--blog.svg-->", Path("icons/blog.svg").read_text())
html = html.replace("<!--til.svg-->", Path("icons/til.svg").read_text())
Path("dist/gallery/index.html").write_text(html)
