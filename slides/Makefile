slides := $(wildcard *.md)

all: $(slides:.md=.pdf)

%.pdf: episodes/%.md
	docker run --rm \
	-v $(shell pwd):/source \
	-w /source slides-builder \
	-t beamer \
	--syntax-definition=bash.xml \
	--listings \
	--include-in-header=header.tex \
	--pdf-engine-opt=-shell-escape \
	--pdf-engine=xelatex $< -o ./pdf/$@ 

slides := episodes/introduction.md \
		episodes/basic_steps.md \
		episodes/library.md \
		episodes/variables.md \
		episodes/targets.md \
		episodes/finding_packages.md \
		episodes/testing.md \
		episodes/additional_topics.md

slides.pdf: $(slides)
	docker run --rm \
	-v $(shell pwd):/source \
	-w /source slides-builder \
	-t beamer \
	--syntax-definition=bash.xml \
	--listings \
	--include-in-header=header.tex \
	--pdf-engine-opt=-shell-escape \
	--pdf-engine=xelatex $(slides) -o ./pdf/$@

clean:
	rm -f *.pdf

.PHONY: all clean
