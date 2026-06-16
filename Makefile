all: blog gallery homepage

.PHONY: blog
blog:
	@typst compile blog/main.typ dist/ --features bundle,html --format bundle --root blog
	@perl -0777 -i -pe 's|^.*</head>||s; \
	                    s|</html>.*||; \
						s|><subtitle>| /><subtitle>|g; \
						s|><published>| /><published>|g' dist/blog/feed.atom
	@printf '<?xml version="1.0" encoding="utf-8"?>' | cat - dist/blog/feed.atom > feed.tmp && mv feed.tmp dist/blog/feed.atom

.PHONY: gallery
gallery:
	@scripts/gallery

.PHONY: homepage
homepage:
	@typst compile homepage/index.typ dist/ --features bundle,html --format bundle --root homepage
