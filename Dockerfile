FROM debian:bullseye-slim

RUN buildDeps="ca-certificates curl fontconfig unzip" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && cd /tmp \
    && curl -SLO https://1001fonts.com/download/fira-mono.zip \
    && curl -SLO https://1001fonts.com/download/fira-sans.zip \
    && unzip fira-mono.zip \
    && unzip fira-sans.zip \
    && mkdir -p /usr/share/fonts/truetype/fira \
    && mv -v *.ttf /usr/share/fonts/truetype/fira \
    && mv -v Fira\ Mono/ttf/*.ttf /usr/share/fonts/truetype/fira \
    && fc-cache -fv \
    && apt-get purge --auto-remove -y $buildDeps \
    && rm -rf /tmp/* /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y curl ca-certificates --no-install-recommends && \    
    curl -fsSL https://deb.nodesource.com/setup_21.x | bash - &&\
    apt-get install -y nodejs &&\
    npm install -g @mermaid-js/mermaid-cli

RUN apt-get update && apt-get install -y --no-install-recommends \
        fonts-fantasque-sans \
        fonts-font-awesome \
        ghostscript \
        graphviz \
        lmodern \
        make \
        pandoc \
        plantuml \
        python3-pandocfilters \
        python3-pip \ 
        texlive-fonts-extra \
        texlive-fonts-recommended \
        texlive-latex-extra \
        texlive-pictures \
        texlive-plain-generic \
        texlive-xetex \
    && pip3 install Pygments  \
    && rm -rf /var/lib/apt/lists/*

COPY filters /usr/local/share/slides-builder/filters

ENTRYPOINT ["pandoc", "--filter", "/usr/local/share/slides-builder/filters/plantuml.py"]
CMD ["--help"]
