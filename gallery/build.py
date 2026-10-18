# sips -s format avif --resampleWidth 800 -o $out $in

import re
from pathlib import Path

main = Path("gallery/index.html").read_text()

for match in re.finditer(r'<img\s+(src="([^"]+)")', main):
    if match[2] == "/favicon.png":
        continue
    img = Path("gallery/assets/" + match[2]).read_bytes()
    ispe = img.find(b"ispe")
    width = int.from_bytes(img[ispe + 8 : ispe + 12], "big")
    height = int.from_bytes(img[ispe + 12 : ispe + 16], "big")
    main = main.replace(match[1], f'width="{width}" height="{height}" {match[1]}')
    main = main.replace(match[2], "/gallery/" + match[2])

html = Path("base.html").read_text()
html = html.replace("<!--title-->", "Aperturic Focus")
html = html.replace(
    "<!--head-->", '<link rel="stylesheet" href="/gallery/style.css" />'
)
html = html.replace("<!--main-->", main)
Path("dist/gallery/index.html").write_text(html)
