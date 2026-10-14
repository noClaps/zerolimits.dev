.PHONY: homepage blog gallery
all: homepage blog gallery

MD := $(wildcard blog/content/*.md)
HTML := $(patsubst blog/content/%.md,dist/blog/%.html,$(MD))

dist/blog/%.html: blog/content/%.md blog/post.html blog/styles/post.css blog/filter.lua
	@pandoc $< \
	    --embed-resources \
	    --resource-path blog/content:. \
		--lua-filter blog/filter.lua \
		--template blog/post.html \
		--output $@

dist/blog/index.html: blog/index.html blog/styles/index.css blog/index.lua
	@pandoc blog/content/*.md \
		--standalone \
	    --template blog/index.html \
		--lua-filter blog/index.lua \
		--embed-resources \
		--output dist/blog/index.html

dist/blog/feed.atom: $(HTML) blog/feed.atom blog/feed.py
	@python3 blog/feed.py

blog:
	@cd blog/helper/ && cargo build --release
	@make -j $(HTML) dist/blog/index.html dist/blog/feed.atom

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
