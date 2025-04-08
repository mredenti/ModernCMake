# Modern CMake

This repository provides slides for a course on Modern CMake, generated with Pandoc through a Docker container. 

## Step 1: Building the Docker Image

You can build the Docker image locally:

```shell
docker build -t slides-builder-pandoc .
```

Alternatively, pull the Docker image directly from GitHub Container Registry:

## Step 2: Generate the slides 

```shell
make CMake.pdf
```

This command compiles all markdown episodes into a single PDF presentation. To clean generated PDFs run: `make clean`.
