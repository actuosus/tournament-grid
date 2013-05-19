TESTS = $(shell find test -name "*.test.js")
REPORTER = spec

install:
	brew install mongo

test:
	NODE_ENV=test ./node_modules/.bin/mocha --bail \
	--timeout 10000 \
	--compilers coffee:coffee-script \
	--require should \
	--reporter $(REPORTER) $(TESTS)

test-w:
	NODE_ENV=test ./node_modules/.bin/mocha --bail \
	--compilers coffee:coffee-script \
	--reporter $(REPORTER) $(TESTS) \
	--require should \
	--watch

gen-cov:
	rm -Rf ./app-cov
	jscoverage app app-cov

test-cov: gen-cov
	@EXPRESS_COV=1 $(MAKE) test REPORTER=html-cov > docs/report/coverage.html

.PHONY: test test-w