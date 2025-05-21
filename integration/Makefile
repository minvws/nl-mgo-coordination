.SILENT: help
all: help

build: ## Build the docker images
	docker compose build

start: ## Start the docker containers
	docker compose up --wait

down:
	docker compose down -v

help: ## Display available commands
	echo "Available make commands:"
	echo
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'
