TESTS = $(shell find test -name "*.test.js")
REPORTER = spec

install:
	brew install mongo
	npm install

run:
	node server.js

run-container:
	docker run -p 49160:3000 -d actuosus/centos-tournament-grid

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

clean:
	rm -fr node_modules

.PHONY: test test-w