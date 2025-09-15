PYTHON = python3

all: help

install-robot: ## Install Robot Framework dependencies
	${PYTHON} -m pip install poetry
	poetry install
	eval $$(poetry env activate) && rfbrowser init

test: ## Start Robot Framework tests

	export $$(grep -v '^#' .env | xargs) ; \
	environment=$(environment) ; \

	eval $$(poetry env activate) && robot \
		--removekeywords tag:secrets \
		--loglevel TRACE:INFO \
		--outputdir=./results \
		-v BROWSER:chromium \
		-v ENVIRONMENT:$$environment \
		-i $$environment \
		tests/; \

	eval $$(poetry env activate) && rebot \
		--removekeywords tag:secrets \
		--output results/final_output.xml \
		results/output.xml

help: ## Display available commands
	@awk 'BEGIN {FS = ":.*##"; printf "\Available make commands: \033[32m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[32m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
