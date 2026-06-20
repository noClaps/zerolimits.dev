.PHONY: blog gallery homepage
all: blog gallery homepage

blog:
	@typst compile blog/main.typ dist/ --features bundle,html --format bundle --root blog
	@perl -0777 -i -pe 's|^.*</head>||s; \
	                    s|</html>.*||; \
						s|><subtitle>| /><subtitle>|g; \
						s|><published>| /><published>|g' dist/blog/feed.atom
	@printf '<?xml version="1.0" encoding="utf-8"?>' | cat - dist/blog/feed.atom > feed.tmp && mv feed.tmp dist/blog/feed.atom

gallery:
	@typst compile gallery/index.typ dist/ --format bundle --features bundle,html --root gallery
	@make $$(cat dist/gallery/index.html | tr '<' '\n' | grep -o 'img src="[^"]*"' | sed -E 's/img src="([^"]*)"/\1/')
/gallery/%.avif: gallery/assets/%.heic
	@mkdir -p $$(dirname "dist$@")
	@sips -s format avif --resampleWidth 800 "$<" --out "dist$@"
	@width=$$(sips -g pixelWidth "dist$@" | perl -ne 'm/pixelWidth: (\d+)/ && print $$1'); \
    height=$$(sips -g pixelHeight "dist$@" | perl -ne 'm/pixelHeight: (\d+)/ && print $$1'); \
	sed -i "" -e "s:<img src=\"$@\":<img src=\"$@\" width=\"$$width\" height=\"$$height\":" dist/gallery/index.html

homepage:
	@typst compile homepage/index.typ dist/ --features bundle,html --format bundle --root homepage
