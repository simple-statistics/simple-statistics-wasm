### `f(x) -> x`

```wasm
(module
  (func
    (export "f")
    (param i32 i32)
    (result i32)
    (get_local 0)))
```

### `add(a, b) -> a + b`

```wasm
(module
  (func
    (export "f")
    (param i32 i32)
    (result i32)
    (i32.add
      (get_local 0)
      (get_local 1))))
```

### `f() -> 42`

```wasm
(module
  (func
    (export "f")
    (result i32)
    (i32.const 42)))
```

### `f(x) -> 1 / (1 + 0.5 * abs(x))`

```wasm
(module
  (func
    (export "f")
    (param f32)
    (result f32)
    (f32.div
      (f32.const 1)
      (f32.add
	(f32.const 1)
	(f32.mul
	  (f32.const 0.5)
	  (f32.abs
	    (get_local 0)))))))
```

## internal method usage `f(x) -> x + 1`

```wasm
(module
 (func $internalmethod
   (param f32)
   (result f32)
   (return (f32.add (f32.const 1) (get_local 0))))

 (func (export "f")
   (param f32)
   (result f32)
   (call $internalmethod (get_local 0))))
```
