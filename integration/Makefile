NEW_UID ?= 1000
NEW_GID ?= 1000
BUILD_PROGRESS ?= auto

.SILENT: help
all: help


build: ## Build the docker images
	./scripts/distribute_signing_keys.sh
	docker compose --progress "${BUILD_PROGRESS}" build --build-arg NEW_UID=${NEW_UID} --build-arg NEW_GID=${NEW_GID} 

start: ## Start the docker containers
# We do this because we want to make use of the docker compose depends_on feature for the load db so we can run the migrations correctly
	docker compose up -d load
	docker compose exec load sh ./tools/migrate_db.sh "" "" "" lo_ad_db
	docker compose up --wait --detach

down:
	docker compose down -v

help: ## Display available commands
	echo "Available make commands:"
	echo
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'
