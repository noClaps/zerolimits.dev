.PHONY: homepage blog gallery
all: homepage blog gallery

MD := $(wildcard blog/content/*.md)
HTML := $(patsubst blog/content/%.md,dist/blog/%.html,$(MD))
dist/blog/%.html: blog/content/%.md
	@pandoc --wrap=none --embed-resources --resource-path blog/content:. --lua-filter blog/filter.lua \
	    --template blog/post.html $< --output $@
blog:
	@cd blog/helper/ && cargo build --release
	@mkdir -p dist/blog/
	@cp -R blog/styles/ dist/blog/
	@make -j $(HTML)
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
