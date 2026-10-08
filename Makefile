.PHONY: homepage gallery

all: homepage gallery
	@typst compile blog/main.typ dist/ --features bundle,html --format bundle --root . --input "posts=$$(command ls blog/content/*.typ)"
	@typst compile blog/feed.typ dist/ --features bundle,html --format bundle --root . --input "posts=$$(command ls blog/content/*.typ)"

homepage:
	@python3 homepage/build.py
gallery:
	@python3 gallery/build.py
