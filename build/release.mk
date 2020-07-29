RELEASE_SCRIPT ?= ./scripts/release.sh

GOTOOLS += github.com/goreleaser/goreleaser

REL_CMD ?= goreleaser
DIST_DIR ?= ./dist

HOMEBREW_CMD ?= brew
HOMEBREW_UPSTREAM ?= git@github.com:newrelic-forks/homebrew-core.git
ARCHIVE_URL       ?= https://github.com/newrelic/$(strip $(PROJECT_NAME))/archive/v$(strip $(PROJECT_VER_TAGGED)).tar.gz

# Example usage: make release version=0.11.0
release: build
	@echo "=== $(PROJECT_NAME) === [ release          ]: Generating release."
	$(RELEASE_SCRIPT) $(version)

release-clean:
	@echo "=== $(PROJECT_NAME) === [ release-clean    ]: distribution files..."
	@rm -rfv $(DIST_DIR) $(SRCDIR)/tmp

release-publish: clean tools docker-login snapcraft-login release-notes
	@echo "=== $(PROJECT_NAME) === [ release-publish  ]: Publishing release via $(REL_CMD)"
	$(REL_CMD) --release-notes=$(SRCDIR)/tmp/$(RELEASE_NOTES_FILE)

# Local Snapshot
snapshot: clean tools release-notes
	@echo "=== $(PROJECT_NAME) === [ snapshot         ]: Creating release via $(REL_CMD)"
	@echo "=== $(PROJECT_NAME) === [ snapshot         ]:   THIS WILL NOT BE PUBLISHED!"
	@$(REL_CMD) --skip-publish --snapshot --release-notes=$(SRCDIR)/tmp/$(RELEASE_NOTES_FILE)

.PHONY: release release-clean release-homebrew release-publish snapshot