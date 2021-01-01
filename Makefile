.DEFAULT_GOAL := all

CONTAINER_HOME := /home/user

# Add 'else ifeq' line to support other env
target := ubuntu
pre-condition:
ifeq ($(target), ubuntu)
	$(eval IMAGE := setup-ubuntu-image)
else
	$(error Supported image list : ubuntu)
endif

# docker run [options] image [command] [arg ...]
define __docker_run
	docker run $(1) ${IMAGE} $(2)
endef

# build
build: pre-condition
	docker build -t ${IMAGE} ubuntu
build-no-cache: pre-condition
	docker build -t ${IMAGE} ubuntu --no-cache
build-clean: pre-condition
	docker rmi -f ${IMAGE}

# debug
debug: pre-condition build
	$(call __docker_run, \
		--interactive \
		--tty \
		, \
		bash \
	)

# install
install: pre-condition build
	$(call __docker_run, \
		, \
		./executor.sh install \
	)

# test
test: pre-condition build
ifdef keyword
	$(call __docker_run, \
		, \
		./executor.sh test -k ${keyword} \
	)
else
	$(call __docker_run, \
		, \
		./executor.sh test\
	)
endif

# all
all: test
