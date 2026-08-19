.PHONY: blog gallery homepage
all: blog gallery homepage

blog:
	@typst compile blog/main.typ dist/ --features bundle,html --format bundle --root blog
	@typst compile blog/feed.typ dist/ --features bundle,html --format bundle --root .

gallery:
	@typst compile gallery/index.typ dist/ --format bundle --features bundle,html --root gallery
	@go run gallery/images.go

homepage:
	@typst compile homepage/index.typ dist/ --features bundle,html --format bundle --root homepage
