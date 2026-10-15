.PHONY: homepage blog gallery til
all: homepage blog gallery til

helper:
	@cd blog/helper/ && cargo build --release

blog: helper
	@mkdir -p dist/blog/
	@cp -R blog/styles/. dist/blog/
	@python3 blog/build.py

homepage:
	@mkdir -p dist/
	@python3 homepage/build.py
	@cp homepage/data.json homepage/global.css homepage/style.css homepage/favicon.png dist/

gallery:
	@mkdir -p dist/gallery/
	@python3 gallery/build.py
	@cp -R gallery/assets/. gallery/style.css dist/gallery/

til: helper
	@mkdir -p dist/til/
	@python3 til/build.py
	@cp til/style.css dist/til/

check:
	@lychee dist --root-dir dist --fallback-extensions html --offline
