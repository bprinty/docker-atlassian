# ~
#
# Makefile for building atlassian development suite.
# 
# @author <bprinty@gmail.com>
# --------------------------------------------------


# config
# ------
REPO                 = bprinty
SERVERS              =
BUILD_OPTS           =


# main targets
# ------------
default: help
	@true


help:
	echo "options: build, tag, run, push, pull"


.PHONY: build
build: $(SERVERS) postgresql


tag:
	for server in $(SERVERS) postgresql; do \
		VERSION=`grep '@version ' $$server/Dockerfile | sed 's/.*@version //g'`; \
		echo docker tag -f $(REPO)/$$server $(REPO)/$$server:$$VERSION; \
	done


run:
	@echo "Running servers."


push:
	@echo "Pushing images to remote locations."


pull:
	@echo "Pulling remote images."


# internal
# --------
postgresql:
	cd postgresql/
	docker build $(BUILD_OPTS) -t $(REPO)/postgresql .


jira:
	cd jira/
	docker build $(BUILD_OPTS) -t $(REPO)/jira .


bamboo:
	cd bamboo/
	docker build $(BUILD_OPTS) -t $(REPO)/bamboo .


confluence:
	cd confluence/
	docker build $(BUILD_OPTS) -t $(REPO)/confluence .
