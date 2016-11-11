# ~
#
# Makefile for building atlassian development suite.
# 
# @author <bprinty@gmail.com>
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
	@echo "    init        - Initialize images and create runnable containers."
	@echo "    start       - Start initialized containers."
	@echo "    stop        - Stop running servers."
	@echo "    clean       - Clean all created images/containers from docker."
	@echo ""
	@echo "Options:"
	@echo "    REPO        - Name of repository to build containers under."
	@echo "    SERVER      - List of servers to operate on (defaults to 'jira bamboo confluence'"
	@echo "    BUILD_OPTS  - Build options for containers."
	@echo "    RUN_OPTS    - Options for running containers (defaults to '--detach')"


build:
	@for server in $(SERVER); do \
		cd $$server && docker build $(BUILD_OPTS) -t $(REPO)/$$server .; \
		cd ..; \
	done


init: build
	@for server in $(SERVER); do \
		PORT=`grep 'EXPOSE ' $$server/Dockerfile | awk '{ print $$2 }'`; \
		docker run $(RUN_OPTS) --name $$server --publish $$PORT:$$PORT $(REPO)/$$server;\
		docker stop $$server; \
	done


start:
	@for server in $(SERVER); do \
		docker start $$server; \
	done


stop:
	@for server in $(SERVER); do \
		docker stop $$server; \
	done


clean:
	@for server in $(SERVER); do \
		docker rm $$server; \
		docker rmi $(REPO)/$$server; \
	done	
