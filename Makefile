.PHONY: blog gallery homepage
all: blog gallery homepage

blog:
	@typst compile blog/main.typ dist/ --features bundle,html --format bundle --root blog
	@typst compile blog/feed.typ dist/ --features bundle,html --format bundle --root .

gallery:
	@typst compile gallery/index.typ dist/ --features bundle,html --format bundle --root gallery

homepage:
	@typst compile homepage/index.typ dist/ --features bundle,html --format bundle --root homepage

images:
	@for file in $$(ls gallery/assets/**/*.heic); do \
	    out=$$(echo $$file | sed s/.heic/.avif/); \
	    sips -s format avif --resampleWidth 800 --out $$out $$file; \
	done
