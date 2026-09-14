.PHONY: blog gallery homepage cli
all: blog gallery homepage cli

blog:
	@typst compile blog/main.typ dist/ --features bundle,html --format bundle
	@typst compile blog/feed.typ dist/ --features bundle,html --format bundle --root .

gallery:
	@typst compile gallery/index.typ dist/ --features bundle,html --format bundle --root .

homepage:
	@typst compile homepage/index.typ dist/ --features bundle,html --format bundle --root .

cli:
	@typst compile cli/index.typ dist/ --features bundle,html --format bundle --root .
