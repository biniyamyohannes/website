# Jekyll Portfolio & Blog

This repository contains my personal portfolio and blog built with [Jekyll](https://jekyllrb.com/) and containerized with Docker for easy setup and reproducibility.

## Features
- Jekyll-based static site (portfolio + blog)
- Dockerfile for consistent environment
- Makefile for simple build/serve commands
- Local development with live reloading

## Usage

### Build the image
```bash
make build
```

### Run the website locally as a container
```bash
make run
```

### Build and run
```bash
make serve
```

### Remove the image
```bash
make clean
```