all: blog gallery homepage

.PHONY: blog
blog:
	@scripts/blog

.PHONY: gallery
gallery:
	@scripts/gallery

.PHONY: homepage
homepage:
	@mkdir -p dist/
	@cp homepage/global.css dist
	@cp homepage/favicon.png dist
	@typst compile homepage/index.typ dist/index.html --features html

clean:
	@rm -rf dist
