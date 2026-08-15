# components-xml-public — verified liturgical components, published as a
# standalone repository.  Components are moved here from the private
# components-xml/ tree as they are checked; sources/ holds the shared
# bibliographic records so the tree is self-contained.
#
#   make lint   validate components and sources against their schemas,
#               and check every source ref resolves to a record
#   make        same (lint is the default target)

COMP_XSD := components.xsd
SRC_XSD := sources.xsd
COMPONENTS := $(wildcard components/*.xml)
SOURCES := $(wildcard sources/*.xml)

.PHONY: lint
lint:
ifneq ($(COMPONENTS),)
	xmllint --noout --schema $(COMP_XSD) $(COMPONENTS)
	@refs=$$(grep -ho 'ref="[^"]*"' components/*.xml | sed 's/ref="//;s/"//' | tr ' ' '\n' | sort -u); \
	missing=0; \
	for r in $$refs; do \
	    test -f "sources/$$r.xml" || { echo "Missing source record: sources/$$r.xml" >&2; missing=1; }; \
	done; \
	test $$missing -eq 0
endif
ifneq ($(SOURCES),)
	xmllint --noout --schema $(SRC_XSD) $(SOURCES)
endif
	@echo "OK: $(words $(COMPONENTS)) component files + $(words $(SOURCES)) source records validate"
