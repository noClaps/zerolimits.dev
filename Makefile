.PHONY: homepage blog gallery
all: homepage blog gallery

blog:
	@cd blog/helper/ && cargo build --release
	@python3 blog/build.py
	@python3 blog/feed.py
homepage:
	@mkdir -p dist/
	@cp homepage/data.json homepage/favicon.png homepage/global.css homepage/style.css dist/
	@python3 homepage/build.py
gallery:
	@mkdir -p dist/gallery/
	@cp -R gallery/style.css gallery/assets/ dist/gallery/
	@python3 gallery/build.py

check:
	@lychee dist --root-dir dist --fallback-extensions html --offline
