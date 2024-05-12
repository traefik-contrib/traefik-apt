-include .env
export

export PKG_DISTRO_UBUNTU22=ubuntu-22.04
export PKG_DISTRO_UBUNTU24=ubuntu-24.04
export PKG_DISTRO_DEBIAN12=debian-12

.PHONY: help
help:
	@echo "Usage: make <target>"

.PHONY: clean_docker_image
clean_docker_image:
	@if docker ps -a | grep -q 'traefik-builder'; then \
		docker stop traefik-builder; \
		docker rm traefik-builder; \
	fi


.PHONY: build_docker_ubuntu_22_04
build_docker_ubuntu_22_04: clean_docker_image
	@echo "Building deb package in docker..."
	mkdir -p build/$(PKG_DISTRO_UBUNTU22)

	docker build \
		--build-arg PKG_NAME=traefik \
		--build-arg PKG_VERSION=3.0.0 \
		--build-arg PKG_RELEASE=1 \
		--build-arg PKG_ARCH=amd64 \
		--build-arg PKG_MAINTAINER="Traefik contrib <traefik.dev@example.com>" \
		--build-arg PKG_DOWNLOAD=https://github.com/traefik/traefik/releases/download/v3.0.0/traefik_v3.0.0_linux_amd64.tar.gz \
		--build-arg BUILD_DIR=/build/traefik-deb \
		-t traefik-deb:$(PKG_DISTRO_UBUNTU22)-$(PKG_VERSION)-$(PKG_RELEASE) \
		-f Dockerfile-$(PKG_DISTRO_UBUNTU22) .
		
	docker run -d --name traefik-builder traefik-deb:$(PKG_DISTRO_UBUNTU22)-$(PKG_VERSION)-$(PKG_RELEASE)

	docker cp traefik-builder:/build/traefik-deb/deb/traefik_$(PKG_VERSION)_$(PKG_ARCH).deb \
		build/$(PKG_DISTRO_UBUNTU22)/traefik_$(PKG_DISTRO_UBUNTU22)-$(PKG_VERSION)_$(PKG_ARCH)-$(PKG_RELEASE).deb


.PHONY: build_docker_ubuntu_24_04
build_docker_ubuntu_24_04: clean_docker_image
	@echo "Building deb package in docker..."
	mkdir -p build/$(PKG_DISTRO_UBUNTU24)

	docker build \
		--build-arg PKG_NAME=traefik \
		--build-arg PKG_VERSION=3.0.0 \
		--build-arg PKG_RELEASE=1 \
		--build-arg PKG_ARCH=amd64 \
		--build-arg PKG_MAINTAINER="Traefik contrib <traefik.dev@example.com>" \
		--build-arg PKG_DOWNLOAD=https://github.com/traefik/traefik/releases/download/v3.0.0/traefik_v3.0.0_linux_amd64.tar.gz \
		--build-arg BUILD_DIR=/build/traefik-deb \
		-t traefik-deb:$(PKG_DISTRO_UBUNTU24)-$(PKG_VERSION)-$(PKG_RELEASE) \
		-f Dockerfile-$(PKG_DISTRO_UBUNTU24) .
		
	docker run -d --name traefik-builder traefik-deb:$(PKG_DISTRO_UBUNTU24)-$(PKG_VERSION)-$(PKG_RELEASE)

	docker cp traefik-builder:/build/traefik-deb/deb/traefik_$(PKG_VERSION)_$(PKG_ARCH).deb \
		build/$(PKG_DISTRO_UBUNTU24)/traefik_$(PKG_DISTRO_UBUNTU24)-$(PKG_VERSION)_$(PKG_ARCH)-$(PKG_RELEASE).deb


.PHONY: build_docker_debian_12
build_docker_debian_12: clean_docker_image
	@echo "Building deb package in docker..."
	mkdir -p build/$(PKG_DISTRO_DEBIAN12)

	docker build \
		--build-arg PKG_NAME=traefik \
		--build-arg PKG_VERSION=3.0.0 \
		--build-arg PKG_RELEASE=1 \
		--build-arg PKG_ARCH=amd64 \
		--build-arg PKG_MAINTAINER="Traefik contrib <traefik.dev@example.com>" \
		--build-arg PKG_DOWNLOAD=https://github.com/traefik/traefik/releases/download/v3.0.0/traefik_v3.0.0_linux_amd64.tar.gz \
		--build-arg BUILD_DIR=/build/traefik-deb \
		-t traefik-deb:$(PKG_DISTRO_DEBIAN12)-$(PKG_VERSION)-$(PKG_RELEASE) \
		-f Dockerfile-$(PKG_DISTRO_DEBIAN12) .
		
	docker run -d --name traefik-builder traefik-deb:$(PKG_DISTRO_DEBIAN12)-$(PKG_VERSION)-$(PKG_RELEASE)

	docker cp traefik-builder:/build/traefik-deb/deb/traefik_$(PKG_VERSION)_$(PKG_ARCH).deb \
		build/$(PKG_DISTRO_DEBIAN12)/traefik_$(PKG_DISTRO_DEBIAN12)-$(PKG_VERSION)_$(PKG_ARCH)-$(PKG_RELEASE).deb



.PHONY: clean
clean:
	rm -rf build/*
	docker rmi traefik-builder
	docker rmi traefik-deb:$(PKG_DISTRO)-$(PKG_VERSION)-$(PKG_RELEASE)
