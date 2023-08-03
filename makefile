client:
	/Applications/love.app/Contents/MacOS/love .

test:
	lua test.lua run

accept:
	lua test.lua accept 

.PHONY: test accept client
