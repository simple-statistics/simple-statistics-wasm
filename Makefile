WAST2WASM=~/src/wabt/out/clang/Debug/wast2wasm
wasm/sum.wasm: wast/sum.wast
	$(WAST2WASM) wast/sum.wast -o wasm/sum.wasm
