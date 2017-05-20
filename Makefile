# WAST2WASM=wast2wasm
WAST2WASM=../wabt/out/clang/Debug/wast2wasm

all: build/error_function.wasm

build:
	mkdir build

build/error_function.wasm: build/error_function.wast
	$(WAST2WASM) ./build/error_function.wast -o ./build/error_function.wasm

build/error_function.wast: build src/error_function.wah
	cd wah && lein run ../src/error_function.wah > ../build/error_function.wast

clean:
	rm build/*
