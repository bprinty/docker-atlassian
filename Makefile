# ~
#
# Makefile for building atlassian development suite.
# 
# @author <bprinty@gmail.com>
# @version 0.0.1
# --------------------------------------------------


# config
# ------
REPO                 = bprinty
SERVER               = jira bamboo confluence
BUILD_OPTS           =
RUN_OPTS             = --detach


# targets
# -------
default: help
	@true


help:
	@echo "Targets:"
	@echo "    build       - Build containers from Dockerfiles in repository."
	@echo "    tag         - Tag built containers using version in repository Dockerfiles."
	@echo "    run         - Run containers for specified servers."
	@echo "    kill        - Kill running containers for specified servers."
	@echo ""
	@echo "Options:"
	@echo "    REPO        - Name of repository to build containers under."
	@echo "    SERVER      - List of servers to operate on (defaults to 'jira bamboo confluence'"
	@echo "    BUILD_OPTS  - Build options for containers."
	@echo "    RUN_OPTS    - Options for running containers (defaults to '--detach')"


tag: build
	@for server in $(SERVER); do \
		VERSION=`grep '@version ' $$server/Dockerfile | sed 's/.*@version //g'`; \
		docker tag $(REPO)/$$server $(REPO)/$$server:$$VERSION; \
	done


build:
	@for server in $(SERVER); do \
		cd $$server && docker build $(BUILD_OPTS) -t $(REPO)/$$server .; \
		cd ..; \
	done


run:
	@for server in $(SERVER); do \
		PORT=`grep 'EXPOSE ' $$server/Dockerfile | awk '{ print $$2 }'`; \
		docker run $(RUN_OPTS) --publish $$PORT:$$PORT $(REPO)/$$server;\
	done


kill:
	@for server in $(SERVER); do \
		CID=`docker ps | grep "$(REPO)/$$server" | awk '{ print $$1 }'`; \
		if [ ! $$CID ]; then \
			echo "No running container found for $(REPO)/$$server"; \
		else \
			docker stop $$CID; \
			docker rm $$CID; \
		fi \
	done
