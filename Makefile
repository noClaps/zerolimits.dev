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
	@typst compile homepage/index.typ dist/index.html --features html
