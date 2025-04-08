# Modern CMake

This repository provides slides for a course on Modern CMake, generated with Pandoc through a Docker container. 

## Step 1: Building the Docker Image

Ensure you have the `Dockerfile` in your working directory (the `Dockerfile` provided above).

Run this command to build your Docker image:

```shell
docker build -t slides-builder .
```

Alternatively, if you have a tagged image from a registry:

```shell
docker pull ghcr.io/mredenti/slides-builder-pandoc:latest
docker tag ghcr.io/mredenti/slides-builder-pandoc:latest slides-builder
```

## Step 2: Generate the slides 

```shell
make CMake.pdf
```

This command compiles all markdown episodes into a single PDF presentation. To clean generated PDFs run: `make clean`.
