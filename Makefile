.PHONY: blog gallery homepage cli
all: blog gallery homepage cli

blog:
	@typst compile blog/main.typ dist/ --features bundle,html --format bundle --root . --input="posts=$$(command ls blog/content/*.typ)"
	@typst compile blog/feed.typ dist/ --features bundle,html --format bundle --root . --input="posts=$$(command ls blog/content/*.typ)"

gallery:
	@typst compile gallery/index.typ dist/ --features bundle,html --format bundle --root .

homepage:
	@typst compile homepage/index.typ dist/ --features bundle,html --format bundle --root .

cli:
	@typst compile cli/index.typ dist/ --features bundle,html --format bundle --root .
