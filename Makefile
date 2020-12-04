DESTDIR ?=
PYTHON ?= $(shell command -v python3 python|head -n1)
PYTHON_VERSION ?= $(shell $(PYTHON) -c 'import sys; print("%s.%s" % (sys.version_info.major, sys.version_info.minor))')
PKG_MANAGER ?= $(shell command -v dnf yum|head -n1)
PIP ?= PIP_DISABLE_VERSION_CHECK=1 $(PYTHON) -m pip

.EXPORT_ALL_VARIABLES:

ANSIBLE_COLLECTIONS_PATH = $(HOME)/.ansible/collections/ansible_collections
ANSIBLE_TEST = cd $(ANSIBLE_COLLECTIONS_PATH)/pycontribs/protogen && ansible-test
ANSIBLE := $(shell command -v ansible)

.PHONY: test sanity units env integration shell coverage network-integration windows-integration lint default help build install devenv

HAS_ANSIBLE := $(shell command -v ansible 2> /dev/null)

default: help

define PRINT_HELP_PYSCRIPT
import re, sys

print("Usage: make <target>")
cmds = {}
for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
	  target, help = match.groups()
	  cmds.update({target: help})
for cmd in sorted(cmds):
		print(" * '%s' - %s" % (cmd, cmds[cmd]))
endef
export PRINT_HELP_PYSCRIPT

help:
	@$(PYTHON) -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

devenv:	 # Assures we have all pre-requisites for testing
ifndef HAS_ANSIBLE
	$(PIP) install --user "ansible-base>=2.10"
endif
	$(ANSIBLE) --version
	@# too avoid: Could not build wheels for ...
	python3 -m pip install --user wheel

build: devenv  ## Builds collection
	sh -c "rm -rf dist/* .cache/collections/* || true"
	@echo build collection
	ansible-galaxy collection build -v -f --output-path dist/

install: build  ## Installs collection
	@echo install collection to $(ANSIBLE_COLLECTIONS_PATH)
	ansible-galaxy collection install -f dist/*.tar.gz -p $(ANSIBLE_COLLECTIONS_PATH)
	@echo validates that collection is reported as installed
	ansible-galaxy collection list | grep 'pycontribs.protogen'

test:  ## Runs ansible-test
	$(ANSIBLE_TEST) ansible-test --help

# BEGIN ansible-test commands
sanity: install  ## Runs ansible-test sanity
	@# see https://github.com/ansible/ansible/issues/72854
	$(PIP) install --user pylint
	$(ANSIBLE_TEST) sanity --requirements --python $(PYTHON_VERSION)

units: install  ## Runs ansible-test units
	$(ANSIBLE_TEST) units --requirements --python $(PYTHON_VERSION)

integration: install  ## posix integration tests [NOT-IMPLEMENTED]
	$(ANSIBLE_TEST) integration --requirements

network-integration: install  ## network integration tests [NOT-IMPLEMENTED]
	$(ANSIBLE_TEST) network-integration --requirements

windows-integration: install  ## windows integration tests [NOT-IMPLEMENTED]
	$(ANSIBLE_TEST) windows-integration --requirements

shell:  ## open an interactive shell
	$(ANSIBLE_TEST) shell

coverage: units ## code coverage management and reporting
	$(ANSIBLE_TEST) units --requirements --python $(PYTHON_VERSION) --coverage
	$(ANSIBLE_TEST) coverage combine
	$(ANSIBLE_TEST) coverage report

env:  ##  show information about the test environment
	$(ANSIBLE_TEST) env
# END of ansible-test commands

# BEGIN tox commands
lint:  ## Lints the code
	tox -e linters

molecule:  ## Runs molecule 'default' scenario
	tox -e molecule
# END of tox commands
