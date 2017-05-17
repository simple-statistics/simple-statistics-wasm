;; based on https://github.com/dspinellis/unix-history-repo/blob/Bell-32V-Snapshot-Development/usr/src/libm/exp.c
(module
 (func $internalmethod
   (param f32)
   (result f32)
   (return (f32.add (f32.const 1) (get_local 0))))

 (func (export "f")
   (param f32)
   (result f32)
   (call $internalmethod (get_local 0)))
)
