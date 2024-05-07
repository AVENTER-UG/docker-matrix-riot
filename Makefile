#Dockerfile vars

#vars
IMAGENAME=docker-matrix-riot
IMAGENAME=docker-matrix-element
IMAGEFULLNAME=avhost/${IMAGENAME}
IMAGEFULLNAME2=avhost/${IMAGENAME2}
BUILDDATE=$(shell date -u +%Y%m%d)
BRANCH=${shell git symbolic-ref --short HEAD}
LASTCOMMIT=$(shell git log -1 --pretty=short | tail -n 1 | tr -d " " | tr -d "UPDATE:")
VERSION=1.11.66

.DEFAULT_GOAL := all

ifeq (${BRANCH}, master) 
	BRANCH=latest
endif

ifneq ($(shell echo $(LASTCOMMIT) | grep -E '^v([0-9]+\.){0,2}(\*|[0-9]+)'),)
	BRANCH=${LASTCOMMIT}
else
	BRANCH=latest
endif


build:
	@echo ">>>> Build docker image: " ${BRANCH}_${BUILDDATE}  
	docker build --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} -t ${IMAGEFULLNAME}:${BRANCH}_${BUILDDATE} .

push:
	@echo ">>>> Publish docker image: " ${BRANCH}_${BUILDDATE}
	@docker buildx create --use --name buildkit
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME}:${BRANCH}_${BUILDDATE} .
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME}:${BRANCH} .
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME}:latest .
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME2}:${BRANCH}_${BUILDDATE} .
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME2}:${BRANCH} .
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME2}:latest .
	@docker buildx rm buildkit


imagecheck:
	trivy image ${IMAGEFULLNAME}:${BRANCH}_${BUILDDATE}

all: build imagecheck
