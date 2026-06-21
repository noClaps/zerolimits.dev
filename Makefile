.PHONY: blog gallery homepage
all: blog gallery homepage

blog:
	@typst compile blog/main.typ dist/ --features bundle,html --format bundle --root blog
	@perl -0777 -i -ne 'printf "<?xml version=\"1.0\" encoding=\"utf-8\"?>$$1" if m|(<feed xmlns="http://www.w3.org/2005/Atom">.*</feed>)|s' dist/blog/feed.atom
	@perl -0777 -i -pe 's|><published|/><published|g; s|><subtitle|/><subtitle|g' dist/blog/feed.atom
	@/usr/bin/perl -Mutf8 -Mopen=':std,:encoding(UTF-8)' -MHTML::Entities=encode_entities -0777 -i -pe 's{(<content type="html">)(.*?)(</content>)}{$$1.encode_entities($$2).$$3}gse' dist/blog/feed.atom

gallery:
	@typst compile gallery/index.typ dist/ --format bundle --features bundle,html --root gallery
	@make -j $$(perl -ne 'printf "dist$$1 " while m/img src="([^"]*)"/g' dist/gallery/index.html)
dist/gallery/%.avif: gallery/assets/%.heic
	@mkdir -p $$(dirname "$@")
	@sips -s format avif --resampleWidth 800 "$<" --out "$@"
	@width=$$(sips -g pixelWidth "$@" | perl -ne 'print m/pixelWidth: (\d+)/'); \
    height=$$(sips -g pixelHeight "$@" | perl -ne 'print m/pixelHeight: (\d+)/'); \
    path=$$(echo "$@" | cut -c 5-); \
	sed -i "" -e "s|<img src=\"$$path\"|<img src=\"$$path\" width=\"$$width\" height=\"$$height\"|" dist/gallery/index.html

homepage:
	@typst compile homepage/index.typ dist/ --features bundle,html --format bundle --root homepage
