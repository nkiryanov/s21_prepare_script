BASH_FILES := $(wildcard *.bash src/*.bash)

lint:
	@shellcheck --enable=require-variable-braces $(BASH_FILES) && echo "ShellCheck passed"

echo:
	@echo $(BASH_FILES)
