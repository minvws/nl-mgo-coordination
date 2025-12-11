.SILENT: help
all: help

submodules-init: ## Initialize all submodules and ensure they are checked out recursively
	git submodule update --init --recursive

submodules-update: ## Sync submodule URLs and update them to the latest commit from their remote branches
	git submodule sync --recursive && git submodule update --recursive --remote

submodules-reset: ## Reset all submodules to their committed state
	git submodule sync --recursive
	git submodule update --init --recursive --force
	git submodule foreach --recursive 'git reset --hard'

help: ## Display available commands
	echo "Available make commands:"
	echo
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'
