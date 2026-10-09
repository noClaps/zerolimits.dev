import re
import xml.etree.ElementTree as ET
from datetime import date, datetime, timezone
from glob import glob
from os import makedirs
from pathlib import Path

posts = [
    p.replace(".typ", "").replace("blog/content/", "")
    for p in glob("blog/content/*.typ")
]

feed = ET.Element("feed", xmlns="http://www.w3.org/2005/Atom")
ET.SubElement(feed, "id").text = "https://zerolimits.dev/blog"
ET.SubElement(feed, "title").text = "The Blog of Random"
ET.SubElement(
    feed, "updated"
).text = f"{datetime.now(tz=timezone.utc).date().isoformat()}T00:00:00Z"
ET.SubElement(feed, "link", rel="self", href="https://zerolimits.dev/blog/feed.atom")
ET.SubElement(
    feed, "subtitle"
).text = "A blog about the most random things you can think of."
author = ET.SubElement(feed, "author")
ET.SubElement(author, "name").text = "noClaps"
ET.SubElement(author, "uri").text = "https://zerolimits.dev"
ET.SubElement(feed, "icon").text = "https://zerolimits.dev/favicon.png"

for post in posts:
    source_lines = Path(f"blog/content/{post}.typ").read_text().splitlines()
    post_date = date.min
    lastmod = None
    for line in source_lines:
        line = line.strip()
        if match := re.match(
            r"date: datetime\(year: (\d+), month: (\d+), day: (\d+)\)", line
        ):
            post_date = date(int(match[1]), int(match[2]), int(match[3]))
        if match := re.match(
            r"lastmod: datetime\(year: (\d+), month: (\d+), day: (\d+)\)", line
        ):
            lastmod = date(int(match[1]), int(match[2]), int(match[3]))

    content = Path("dist/blog/" + post + ".html").read_text()
    article = content[
        content.find("<article>") + len("<article>") : content.find("</article>")
    ]
    title = content[content.find("<title>") + len("<title>") : content.find("<title>")]
    updated = lastmod if lastmod is not None else post_date

    entry = ET.SubElement(feed, "entry")
    ET.SubElement(entry, "id").text = f"https://zerolimits.dev/blog/{post}"
    ET.SubElement(entry, "title").text = title
    ET.SubElement(entry, "updated").text = f"{updated.isoformat()}T00:00:00Z"
    ET.SubElement(
        entry, "link", rel="alternate", href=f"https://zerolimits.dev/blog/{post}"
    )
    ET.SubElement(entry, "published").text = f"{post_date.isoformat()}T00:00:00Z"
    ET.SubElement(entry, "content", type="html").text = article

makedirs("dist/blog/", exist_ok=True)
Path("dist/blog/feed.atom").write_text(
    ET.tostring(feed, xml_declaration=True, encoding="unicode")
)
