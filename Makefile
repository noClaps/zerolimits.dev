all:
	@typst compile main.typ dist/ --features bundle,html --format bundle --input "posts=$$(command ls blog/content/*.typ)"
	@typst compile blog/feed.typ dist/ --features bundle,html --format bundle --root . --input="posts=$$(command ls blog/content/*.typ)"

serve:
	@typst watch main.typ dist/ --features bundle,html --format bundle --input "posts=$$(command ls blog/content/*.typ)"
