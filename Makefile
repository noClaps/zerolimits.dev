.PHONY: homepage blog gallery
all: homepage blog gallery

MD := $(wildcard blog/content/*.md)
HTML := $(patsubst blog/content/%.md,dist/blog/%.html,$(MD))

dist/blog/%.html: blog/content/%.md blog/post.html blog/styles/post.css blog/post.lua
	@pandoc $< \
	    --wrap none \
	    --embed-resources \
	    --resource-path blog/content:. \
		--lua-filter blog/post.lua \
		--template blog/post.html \
		--output $@

dist/blog/index.html: blog/index.html blog/styles/index.css blog/index.lua
	@pandoc blog/content/*.md \
		--wrap none \
	    --template blog/index.html \
		--lua-filter blog/index.lua \
		--embed-resources \
		--output dist/blog/index.html

dist/blog/feed.atom: $(HTML) blog/feed.atom blog/feed.lua
	@pandoc blog/content/*.md \
		--wrap none \
		--template blog/feed.atom \
		--lua-filter blog/feed.lua \
		--output dist/blog/feed.atom

blog:
	@cd blog/helper/ && cargo build --release
	@make -j $(HTML) dist/blog/index.html dist/blog/feed.atom

homepage:
	@pandoc homepage/index.html \
		--embed-resources \
	    --template homepage/index.html \
		--lua-filter homepage/build.lua \
		--output dist/index.html
	@cp homepage/data.json homepage/global.css homepage/favicon.png dist/

gallery:
	@python3 gallery/build.py
	@cp -R gallery/assets/ gallery/style.css dist/gallery/

check:
	@lychee dist --root-dir dist --fallback-extensions html --offline
