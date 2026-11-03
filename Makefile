.PHONY: base homepage blog gallery til friends
all: homepage blog gallery til friends

base:
	@mkdir -p dist/
	@cp global.css favicon.png dist/

blog: base
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

til: base
	@mkdir -p dist/til/
	@python3 til/build.py
	@cp til/style.css dist/til/

friends: base
	@mkdir -p dist/friends/
	@python3 friends/build.py
	@cp friends/88x31.png friends/style.css dist/friends/

check:
	@lychee dist --root-dir dist --fallback-extensions html --offline

imgoptim:
	@imgoptim -r blog/content/assets/
