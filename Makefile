.PHONY: base homepage blog gallery til highlighter
all: homepage blog gallery til

base:
	@mkdir -p dist/
	@cp global.css favicon.png dist/

highlighter:
	@cd highlighter/ && go build -o highlighter

blog: base highlighter
	@mkdir -p dist/blog/
	@cp -R blog/styles/. dist/blog/
	@python3 blog/build.py

homepage: base
	@python3 homepage/build.py
	@cp homepage/data.json homepage/style.css dist/

gallery: base
	@mkdir -p dist/gallery/
	@python3 gallery/build.py
	@cp -R gallery/assets/. gallery/style.css dist/gallery/

til: base highlighter
	@mkdir -p dist/til/
	@python3 til/build.py
	@cp til/style.css dist/til/

check:
	@lychee dist --root-dir dist --fallback-extensions html --offline
