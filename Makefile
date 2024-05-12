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

define docker_build
	@echo "Building deb package in docker for $(1)..."
	mkdir -p build/$(1)

	# build docker image
	docker build \
		--build-arg PKG_NAME=$(PKG_NAME) \
		--build-arg PKG_VERSION=$(PKG_VERSION) \
		--build-arg PKG_RELEASE=$(PKG_RELEASE) \
		--build-arg PKG_ARCH=$(PKG_ARCH) \
		--build-arg PKG_MAINTAINER='$(PKG_MAINTAINER)' \
		--build-arg PKG_DOWNLOAD=$(PKG_DOWNLOAD) \
		--build-arg BUILD_DIR=$(BUILD_DIR) \
		-t traefik-deb:$(1)-$(PKG_VERSION)-$(PKG_RELEASE) \
		-f Dockerfile-$(1) .

	# run docker container only for get access do deb package
	docker run -d --name traefik-builder traefik-deb:$(1)-$(PKG_VERSION)-$(PKG_RELEASE)

	# cp deb package from docker container
	docker cp \
		traefik-builder:/build/traefik-deb/deb/traefik_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH).deb \
    	build/$(1)/traefik_$(PKG_VERSION)-$(PKG_RELEASE)_$(PKG_ARCH).deb

	# destroy docker container
	docker stop traefik-builder
	docker rm traefik-builder
endef


.PHONY: build_docker_ubuntu_22_04
build_docker_ubuntu_22_04: clean_docker_image
	$(call docker_build,$(PKG_DISTRO_UBUNTU22))

.PHONY: build_docker_ubuntu_24_04
build_docker_ubuntu_24_04: clean_docker_image
	$(call docker_build,$(PKG_DISTRO_UBUNTU24))

.PHONY: build_docker_debian_12
build_docker_debian_12: clean_docker_image
	$(call docker_build,$(PKG_DISTRO_DEBIAN12))

.PHONY: clean
clean:
	rm -rf build/*
	docker rmi $(shell docker images -q traefik-deb)
	