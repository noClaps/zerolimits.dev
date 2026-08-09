.PHONY: blog gallery homepage
all: blog gallery homepage

blog:
	@typst compile blog/main.typ dist/ --features bundle,html --format bundle --root blog
	@typst compile blog/feed.typ dist/ --features bundle,html --format bundle --root .

gallery:
	@typst compile gallery/index.typ dist/ --format bundle --features bundle,html --root gallery
	@make -j $$(perl -ne 'printf "dist$$1 " while m/img src="([^"]*)"/g' dist/gallery/index.html)
dist/gallery/%.avif: gallery/assets/%.heic
	@mkdir -p $$(dirname "$@")
	@imgoptim optimise "$<" "$@" --width 800
	@width=$$(imgoptim width "$@"); \
	height=$$(imgoptim height "$@"); \
	path=$$(echo "$@" | cut -c 5-); \
	perl -pi -e "s|<img src=\"$$path\"|<img src=\"$$path\" width=\"$$width\" height=\"$$height\"|" dist/gallery/index.html
	@echo "$< -> $@"

homepage:
	@typst compile homepage/index.typ dist/ --features bundle,html --format bundle --root homepage
