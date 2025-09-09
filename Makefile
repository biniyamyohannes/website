# Makefile for Jekyll blog with custom Dockerfile

IMAGE = my-jekyll-site
PORT = 4000

.PHONY: build run serve clean

build:
	docker build -t $(IMAGE) .

run:
	docker run --rm -p $(PORT):4000 $(IMAGE)

serve: build run

clean:
	docker rmi $(IMAGE) || true
