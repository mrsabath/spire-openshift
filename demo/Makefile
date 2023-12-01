.PHONY: bin/demo container-demo

GIT_COMMIT_SHA="$(shell git rev-parse --short HEAD 2>/dev/null)"
REPO ?= tsidentity
DEMO_IMG_NAME ?= spire-demo
VERSION=$(shell cat ../version.txt)
# GO_FILES := $(shell find . -type f -name '*.go' -not -name '*_test.go' -not -path './vendor/*')

DEMO_IMG := $(REPO)/$(DEMO_IMG_NAME):$(GIT_COMMIT_SHA)
DEMO_IMG_MUTABLE := $(REPO)/$(DEMO_IMG_NAME):$(VERSION)
DEMO_IMG_LATEST := $(REPO)/$(DEMO_IMG_NAME):latest

all: bin/demo container-demo

bin/demo:
	docker build --no-cache -t $(DEMO_IMG) -f Dockerfile.demo .
	docker tag $(DEMO_IMG) $(DEMO_IMG_MUTABLE)
	docker tag $(DEMO_IMG) $(DEMO_IMG_LATEST)

container-demo:
	docker push $(DEMO_IMG)
	docker push $(DEMO_IMG_MUTABLE)
	docker push $(DEMO_IMG_LATEST)

# vendor:
# 	go mod tidy
# 	go mod vendor
