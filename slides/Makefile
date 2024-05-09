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

clean:
	rm -f *.pdf

.PHONY: all clean
