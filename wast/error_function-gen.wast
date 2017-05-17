(module
 (func
  $exp
  (param f64)
  (result f64)
  (local $ent f64)
  (local $fract f64)
  (local $temp1 f64)
  (local $temp2 f64)
  (local $xsq f64)
  (local $p0 f64)
  (local $p1 f64)
  (local $p2 f64)
  (local $q0 f64)
  (local $q1 f64)
  (local $q2 f64)
  (local $log2e f64)
  (local $sqrt2 f64)
  (local $maxf f64)
  (set_local $p0 (f64.const 2080384.346694663))
  (set_local $p1 (f64.const 30286.971697440364))
  (set_local $p2 (f64.const 60.61485330061081))
  (set_local $q0 (f64.const 6002720.360238832))
  (set_local $q1 (f64.const 327725.15180829144))
  (set_local $q2 (f64.const 1749.2876890930763))
  (set_local $log2e (f64.const 1.4426950408889634))
  (set_local $sqrt2 (f64.const 1.4142135623730951))
  (set_local $maxf (f64.const 10000))
  (if
   f64
   (f64.eq (get_local 0) (f64.const 0))
   (then (f64.const 1))
   (else
    (if
     f64
     (f64.lt (get_local 0) (f64.mul (f64.const -1) (get_local $maxf)))
     (then (f64.const 0))
     (else
      (if
       f64
       (f64.gt (get_local 0) (get_local $maxf))
       (then (f64.const -1))
       (else
        (set_local 0 (f64.mul (get_local 0) (get_local $log2e)))
        (set_local $ent (f64.trunc (get_local 0)))
        (set_local
         $fract
         (f64.sub
          (f64.sub (get_local 0) (get_local $ent))
          (f64.const 0.5)))
        (set_local
         $xsq
         (f64.mul (get_local $fract) (get_local $fract)))
        (set_local
         $temp1
         (f64.mul
          (get_local $fract)
          (f64.add
           (get_local $p0)
           (f64.mul
            (get_local $xsq)
            (f64.add
             (get_local $p1)
             (f64.mul (get_local $xsq) (get_local $p2)))))))
        (set_local
         $temp2
         (f64.add
          (get_local $q0)
          (f64.mul
           (get_local $xsq)
           (f64.add
            (get_local $q1)
            (f64.mul
             (get_local $xsq)
             (f64.add
              (get_local $q2)
              (f64.mul (get_local $xsq) (f64.const 0))))))))
        (return
         (f64.mul
          (f64.mul
           (get_local $sqrt2)
           (f64.div
            (f64.add (get_local $temp1) (get_local $temp2))
            (f64.sub (get_local $temp2) (get_local $temp1))))
          (f64.convert_s/i32
           (i32.shl
            (i32.const 2)
            (i32.trunc_s/f64
             (f64.sub (get_local $ent) (f64.const 1))))))))))))))
 (func
  (export "errorFunction")
  (param f64)
  (result f64)
  (local $t f64)
  (local $accum f64)
  (local $tau f64)
  (set_local
   $t
   (f64.div
    (f64.const 1)
    (f64.add
     (f64.const 1)
     (f64.mul (f64.const 0.5) (f64.abs (get_local 0))))))
  (set_local $accum (get_local $t))
  (set_local
   $tau
   (f64.sub
    (f64.mul (f64.const -1) (f64.mul (get_local 0) (get_local 0)))
    (f64.const 1.26551223)))
  (set_local
   $tau
   (f64.add
    (get_local $tau)
    (f64.mul (get_local $t) (f64.const 1.00002368))))
  (set_local $accum (f64.mul (get_local $t) (get_local $accum)))
  (set_local
   $tau
   (f64.add
    (get_local $tau)
    (f64.mul (get_local $accum) (f64.const 0.37409196))))
  (set_local $accum (f64.mul (get_local $t) (get_local $accum)))
  (set_local
   $tau
   (f64.add
    (get_local $tau)
    (f64.mul (get_local $accum) (f64.const 0.09678418))))
  (set_local $accum (f64.mul (get_local $t) (get_local $accum)))
  (set_local
   $tau
   (f64.sub
    (get_local $tau)
    (f64.mul (get_local $accum) (f64.const 0.18628806))))
  (set_local $accum (f64.mul (get_local $t) (get_local $accum)))
  (set_local
   $tau
   (f64.add
    (get_local $tau)
    (f64.mul (get_local $accum) (f64.const 0.27886807))))
  (set_local $accum (f64.mul (get_local $t) (get_local $accum)))
  (set_local
   $tau
   (f64.sub
    (get_local $tau)
    (f64.mul (get_local $accum) (f64.const 1.13520398))))
  (set_local $accum (f64.mul (get_local $t) (get_local $accum)))
  (set_local
   $tau
   (f64.add
    (get_local $tau)
    (f64.mul (get_local $accum) (f64.const 1.48851587))))
  (set_local $accum (f64.mul (get_local $t) (get_local $accum)))
  (set_local
   $tau
   (f64.sub
    (get_local $tau)
    (f64.mul (get_local $accum) (f64.const 0.82215223))))
  (set_local $accum (f64.mul (get_local $t) (get_local $accum)))
  (set_local
   $tau
   (f64.add
    (get_local $tau)
    (f64.mul (get_local $accum) (f64.const 0.17087277))))
  (set_local $tau (call $exp (get_local $tau)))
  (if
   f64
   (f64.ge (get_local 0) (f64.const 0))
   (then (f64.sub (f64.const 1) (get_local $tau)))
   (else (f64.sub (get_local $tau) (f64.const 1))))))
