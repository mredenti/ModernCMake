CMake := $(wildcard *.md)

all: $(CMake:.md=.pdf)

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

CMake := episodes/introduction.md \
		episodes/basic_steps.md \
		episodes/library.md \
		episodes/variables.md \
		episodes/targets.md \
		episodes/finding_packages.md \
		episodes/testing.md \
		episodes/generator_expressions.md \
		episodes/additional_topics.md

CMake.pdf: $(CMake)
	docker run --rm \
	-v $(shell pwd):/source \
	-w /source slides-builder \
	-t beamer \
	--syntax-definition=bash.xml \
	--listings \
	--include-in-header=header.tex \
	--pdf-engine-opt=-shell-escape \
	--pdf-engine=xelatex $(CMake) -o ./pdf/$@

clean:
	rm -f *.pdf

.PHONY: all clean
