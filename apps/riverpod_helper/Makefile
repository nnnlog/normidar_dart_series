

.DEFAULT_GOAL := help
.PHONY: help
help:
	@echo "List of available make commands";
	@echo "";
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}';
	@echo "";

.PHONY: clean
clean: ## clean and get dependencies
	flutter clean
	flutter pub get

.PHONY: format 
format: ## format the library code
	dart format lib/

.PHONY: check
check: ## Analyze, Fix, Format the library.
	flutter analyze
	dart fix --apply
	dart format .