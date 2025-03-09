# Makefile for Sphinx documentation
.DEFAULT_GOAL   = help
SHELL           = bash

# You can set these variables from the command line.
SPHINXOPTS      ?=
PAPER           ?=

# Internal variables.
SPHINXBUILD     = "$(realpath .venv/bin/sphinx-build)"
SPHINXAUTOBUILD = "$(realpath .venv/bin/sphinx-autobuild)"
DOCS_DIR        = ./docs/
BUILDDIR        = ../_build
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
VALEFILES       := $(shell find $(DOCS_DIR) -type f -name "*.md" -print)
VALEOPTS        ?=
PYTHONVERSION   = >=3.11,<3.14

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
.PHONY: help
help:  # This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


# environment management
.PHONY: dev
dev:  ## Install required Python, create Python virtual environment, and install package requirements
	@uv python install "$(PYTHONVERSION)"
	@uv venv --python "$(PYTHONVERSION)"
	@uv sync

.PHONY: sync
sync:  ## Sync package requirements
	@uv sync

.PHONY: init
init: clean clean-python dev  ## Clean docs build directory and initialize Python virtual environment

.PHONY: clean
clean:  ## Clean docs build directory
	cd $(DOCS_DIR) && rm -rf $(BUILDDIR)/

.PHONY: clean-python
clean-python: clean
	rm -rf .venv/
# /environment management


# documentation builders
.PHONY: html
html: dev  ## Build html
	cd $(DOCS_DIR) && $(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

.PHONY: livehtml
livehtml: dev  ## Rebuild Sphinx documentation on changes, with live-reload in the browser
	cd "$(DOCS_DIR)" && ${SPHINXAUTOBUILD} \
		--ignore "*.swp" \
		--port 8050 \
		-b html . "$(BUILDDIR)/html" $(SPHINXOPTS) $(O)

.PHONY: dirhtml
dirhtml: dev
	cd $(DOCS_DIR) && $(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

.PHONY: singlehtml
singlehtml: dev
	cd $(DOCS_DIR) && $(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo
	@echo "Build finished. The HTML page is in $(BUILDDIR)/singlehtml."

.PHONY: text
text: dev
	cd $(DOCS_DIR) && $(SPHINXBUILD) -b text $(ALLSPHINXOPTS) $(BUILDDIR)/text
	@echo
	@echo "Build finished. The text files are in $(BUILDDIR)/text."

.PHONY: changes
changes: dev
	cd $(DOCS_DIR) && $(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."
# /documentation builders


# test
.PHONY: linkcheck
linkcheck: dev  ## Run linkcheck
	cd $(DOCS_DIR) && $(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
		"or in $(BUILDDIR)/linkcheck/ ."

.PHONY: linkcheckbroken
linkcheckbroken: dev  ## Run linkcheck and show only broken links
	cd $(DOCS_DIR) && $(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck | GREP_COLORS='0;31' grep -wi "broken\|redirect" --color=always | GREP_COLORS='0;31' grep -vi "https://github.com/plone/volto/issues/" --color=always && if test $$? = 0; then exit 1; fi || test $$? = 1
	@echo
	@echo "Link check complete; look for any errors in the above output " \
		"or in $(BUILDDIR)/linkcheck/ ."

.PHONY: vale
vale: dev  ## Run Vale style, grammar, and spell checks
	@uv run vale sync
	@uv run vale --no-wrap $(VALEOPTS) $(VALEFILES)
	@echo
	@echo "Vale is finished; look for any errors in the above output."

.PHONY: doctest
doctest: dev  ## Test snippets in the documentation
	cd $(DOCS_DIR) && $(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."

.PHONY: test
test: clean vale linkcheckbroken doctest  ## Clean docs build, then run vale and linkcheckbroken
# /test


# development
.PHONY: html_meta
html_meta: dev  ## Add meta data headers to all Markdown pages
	python ./docs/addMetaData.py

.PHONY: kitchen-sink-update
kitchen-sink-update:  ## Copy Kitchen Sink documentation files to Plone Sphinx Theme
	@uv run python scripts/kitchen_sink_update.py

.PHONY: sbt-styles-update
sbt-styles-update:  ## Copy Sphinx Book Theme styles to Plone Sphinx Theme
	@uv run python scripts/sbt_styles_update.py

.PHONY: serve
serve:  ## Compile static assets, build and serve the docs, and reload the browser on changes
	@uv run stb serve docs/

.PHONY: compile
compile:  ## Compile static assets
	@uv run stb compile

.PHONY: rtd-prepare
rtd-prepare:  ## Prepare environment on Read the Docs
	asdf plugin add uv
	asdf install uv latest
	asdf global uv latest

.PHONY: rtd-pr-preview
rtd-pr-preview: rtd-prepare dev ## Build pull request preview on Read the Docs
	cd $(DOCS_DIR) && $(SPHINXBUILD) -b html $(ALLSPHINXOPTS) ${READTHEDOCS_OUTPUT}/html/

.PHONY: release
release: dev compile  ## Release with zest.releaser
	@uv run fullrelease

.PHONY: all
all: clean vale linkcheck html  ## Clean docs build, then run vale and linkcheck, and build html
# /development

.PHONY: deploy
deploy: clean html
