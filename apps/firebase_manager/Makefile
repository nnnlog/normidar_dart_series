
.DEFAULT_GOAL := help

help:
	@echo "List of available make commands";
	@echo "";
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}';
	@echo "";

.PHONY: export
export: ## Export the library to main folder
	./scripts/auto_export.sh

.PHONY: update
update: ## Update all the library
	flutter pub upgrade --major-versions

.PHONY: check
check: ## Analyze, Fix, Format the library.
	flutter analyze
	dart fix --apply
	dart format .