.PHONY: blog gallery homepage
all: blog gallery homepage

blog:
	@typst compile blog/main.typ dist/ --features bundle,html --format bundle
	@typst compile blog/feed.typ dist/ --features bundle,html --format bundle --root .

gallery:
	@typst compile gallery/index.typ dist/ --features bundle,html --format bundle

homepage:
	@typst compile homepage/index.typ dist/ --features bundle,html --format bundle
