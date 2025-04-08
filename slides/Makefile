CMake := $(wildcard *.md)

all: $(CMake:.md=.pdf)

%.pdf: episodes/%.md
	docker run --rm \
	-v $(shell pwd):/source \
	-w /source ghcr.io/mredenti/slides-builder-pandoc:latest \
	-t beamer \
	--syntax-definition=bash.xml \
	--listings \
	--include-in-header=header.tex \
	--pdf-engine-opt=-shell-escape \
	--pdf-engine=xelatex $< -o ./pdf/$@ 

CMake := episodes/introduction.md \
		episodes/basic_steps.md \
		episodes/exercise.md \
		episodes/library.md \
		episodes/language.md \
		episodes/variables.md \
		episodes/targets.md \
		episodes/finding_packages.md \
		episodes/testing.md \
		episodes/additional_topics.md

CMake.pdf: $(CMake)
	docker run --rm \
	-v $(shell pwd):/source \
	-w /source ghcr.io/mredenti/slides-builder-pandoc:latest \
	-t beamer \
	--syntax-definition=bash.xml \
	--listings \
	--include-in-header=header.tex \
	--pdf-engine-opt=-shell-escape \
	--pdf-engine=xelatex $(CMake) -o ./pdf/$@

clean:
	rm -f *.pdf

.PHONY: all clean
