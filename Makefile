#Dockerfile vars

#vars
IMAGENAME=docker-matrix-riot
IMAGENAME2=docker-matrix-element
IMAGEFULLNAME=avhost/${IMAGENAME}
IMAGEFULLNAME2=avhost/${IMAGENAME2}
BUILDDATE=$(shell date -u +%Y%m%d)
BRANCH=$(shell git symbolic-ref --short HEAD | xargs basename)
BRANCHSHORT=$(shell echo ${BRANCH} | awk -F. '{ print $$1"."$$2 }')
LASTCOMMIT=$(shell git log -1 --pretty=short | tail -n 1 | tr -d " " | tr -d "UPDATE:")
VERSION=1.11.69

.DEFAULT_GOAL := all

ifeq (${BRANCH}, master) 
        BRANCH=latest
        BRANCHSHORT=latest
endif

build:
	@echo ">>>> Build docker image: " ${BRANCH} 
	docker build --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} -t ${IMAGEFULLNAME}:${BRANCH} .

push:
	@echo ">>>> Publish docker image: " ${BRANCH} ${BRANCHSHORT}
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME}:${BRANCH} .
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME}:${BRANCHSHORT} .
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME}:latest .
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME2}:${BRANCH} .
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME2}:${BRANCHSHORT} .
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --build-arg BV_VEC=v${VERSION} --build-arg VERSION=${VERSION} --push -t ${IMAGEFULLNAME2}:latest .
	@docker buildx rm buildkit

imagecheck:
	trivy image ${IMAGEFULLNAME}:${BRANCH}

all: build imagecheck
