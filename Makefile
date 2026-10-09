.PHONY: homepage blog gallery
all: homepage blog gallery

blog:
	@python3 blog/build.py
	@python3 blog/feed.py
homepage:
	@python3 homepage/build.py
gallery:
	@python3 gallery/build.py

check:
	@lychee dist --root-dir dist --fallback-extensions html --offline
