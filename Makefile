# Setup ————————————————————————————————————————————————————————————————————————
current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Executables: local
DOCKER-EXEC   	  		= docker
DOCKER_COMPOSE-EXEC   	= docker # todo: Docker Compose is now in the Docker CLI

## —— folders —————————————————————————————————————————————————————————————————

current-dir 		:= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

## —— Docker  ————————————————————————————————————————————————————————
up-dev:
	ENV=dev docker compose \
		-f docker-compose.yml \
		up -d --remove-orphans

stop-dev:
	ENV=dev docker compose \
		-f docker-compose.yml \
		stop

rebuild-dev:
	ENV=dev docker compose \
		-f docker-compose.yml \
		build \
		--no-cache

# 🐘 Composer
.PHONY: composer-env-file
composer-env-file:
	@if [ ! -f .env ]; then cp .env.dist .env; fi

.PHONY: deps
deps: composer-install

.PHONY: composer-install
composer-install: CMD=install

.PHONY: composer-update
composer-update: CMD=update

.PHONY: composer-require
composer-require: CMD=require
composer-require: INTERACTIVE=-ti --interactive

.PHONY: composer-require-module
composer-require-module: CMD=require $(module)
composer-require-module: INTERACTIVE=-ti --interactive

.PHONY: composer
composer composer-install composer-update composer-require composer-require-module: composer-env-file
	@docker run --rm $(INTERACTIVE) --volume $(current-dir):/app --user $(id -u):$(id -g) \
		composer:2.3.7 $(CMD) \
			--ignore-platform-reqs \
			--no-ansi \
			--no-interaction
