# Makefile

.PHONY: all test lint

all: test lint

test:
	rspec

lint:
	rubocop -A