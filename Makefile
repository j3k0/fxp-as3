SOURCE_FILES=src/fxp/core/F.as src/fxp/monads/Maybe.as
TEST_FILES=test/Main.as test/assert.as

test: bin/test.swf
	adl test/Main-app.xml bin

bin/fxp.swc: $(SOURCE_FILES)
	docker run --rm -it -v `pwd`:/src jeko/airbuild amxmlc -output bin/fxp.swc -compiler.source-path=src src/fxp/core/F.as

bin/test.swf: $(SOURCE_FILES) $(TEST_FILES)
	docker run --rm -it -v `pwd`:/src jeko/airbuild amxmlc -output bin/Main.swf -compiler.debug -compiler.source-path=src -compiler.source-path=test test/Main.as

clean:
	rm -fr bin
