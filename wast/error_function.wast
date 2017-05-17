(module

;; based on https://github.com/dspinellis/unix-history-repo/blob/Bell-32V-Snapshot-Development/usr/src/libm/exp.c
  (func $exp
 (param f32)
 (result f32)

 (local $ent f32)
 (local $fract f32)
 (local $temp1 f32)
 (local $temp2 f32)
 (local $xsq f32)
 (local $p0 f32)
 (local $p1 f32)
 (local $p2 f32)
 (local $q0 f32)
 (local $q1 f32)
 (local $q2 f32)
 (local $log2e f32)
 (local $sqrt2 f32)
 (local $maxf f32)

 (set_local $p0 (f32.const 2080384.346694663))
 (set_local $p1 (f32.const 30286.971697440364))
 (set_local $p2 (f32.const 60.61485330061081))
 (set_local $q0 (f32.const 6002720.360238832))
 (set_local $q1  (f32.const 327725.15180829144))
 (set_local $q2  (f32.const 1749.2876890930763))
 (set_local $log2e (f32.const 1.4426950408889634073599247))
 (set_local $sqrt2 (f32.const 1.4142135623730950488016887))
 (set_local $maxf (f32.const 10000))

     (if f32 (f32.eq (get_local 0) (f32.const 0))
       (then (f32.const 1))
     (else (if f32 (f32.lt (get_local 0) (f32.mul (f32.const -1) (get_local $maxf)))
       (then (f32.const 0))
     (else (if f32 (f32.gt (get_local 0) (get_local $maxf))
       (then (f32.const -1)) ;; TODO: throw error
     (else
       (set_local 0 (f32.mul (get_local 0) (get_local $log2e)))
       (set_local $ent (f32.trunc (get_local 0)))
       (set_local $fract
     (f32.sub
             (f32.sub
               (get_local 0)
               (get_local $ent)) (f32.const 0.5)))
       (set_local $xsq (f32.mul (get_local $fract) (get_local $fract)))
       (set_local $temp1
     (f32.mul
       (get_local $fract
       (f32.add
         (get_local $p0)
         (f32.mul
           (get_local $xsq)
           (f32.add
         (get_local $p1)
         (f32.mul (get_local $xsq) (get_local $p2))))))))
       (set_local $temp2
     (f32.add
       (get_local $q0)
       (f32.mul
         (get_local $xsq
         (f32.add
           (get_local $q1)
           (f32.mul
         (get_local $xsq)
         (f32.add
           (get_local $q2)
           (f32.mul (get_local $xsq) (f32.const 0)))))))))


      ;; return(ldexp(sqrt2*(temp2+temp1)/(temp2-temp1), ent));
       (return
     (f32.mul
        (f32.div
          (f32.mul
            (get_local $sqrt2)
            (f32.add
              (get_local $temp1)
              (get_local $temp2)))
          (f32.sub
            (get_local $temp2)
            (get_local $temp1)))
      (f32.convert_s/i32
       (i32.shl
         (i32.const 2)
         (i32.trunc_s/f32
          (f32.sub
        (get_local $ent)
        (f32.const 1)
        )))))))))))))












  ;; TODO: this recursive exp implementation is from
  ;; https://stackoverflow.com/questions/3518973/floating-point-exponentiation-without-power-function
  ;; but it doesn't work yet.
  (func (export "errorFunction")
    (param f32)
    (result f32)
    (local $t f32)
    (local $accum f32)
    (local $tau f32) ;; t = 1 / (1 + 0.5 * abs(x))
    (set_local $t
           (f32.div
             (f32.const 1)
             (f32.add
               (f32.const 1)
               (f32.mul
                 (f32.const 0.5)
                 (f32.abs
                   (get_local 0))))))
    (set_local $accum (get_local $t))

    ;; -Math.pow(x, 2) - 1.265...
    (set_local $tau
      (f32.sub
    (f32.mul
      (f32.const -1)
      (f32.mul ;; x * x
        (get_local 0)
        (get_local 0)))
    (f32.const 1.26551223)))

    ;; + 1.00002368 * t
    (set_local $tau
           (f32.add
         (get_local $tau)
         (f32.mul
           (get_local $t)
           (f32.const 1.00002368))))

    ;; accum = Math.pow(t, 2);
    (set_local $accum (f32.mul (get_local $t) (get_local $accum)))
    (set_local $tau
      (f32.add
        (get_local $tau)
        (f32.mul (get_local $accum) (f32.const 0.37409196))))

    ;; accum = Math.pow(t, 3);
    (set_local $accum (f32.mul (get_local $t) (get_local $accum)))
    (set_local $tau
      (f32.add
        (get_local $tau)
        (f32.mul (get_local $accum) (f32.const 0.09678418))))

    ;; accum = Math.pow(t, 4);
    (set_local $accum (f32.mul (get_local $t) (get_local $accum)))
    (set_local $tau
      (f32.sub
        (get_local $tau)
        (f32.mul (get_local $accum)
                 (f32.const 0.18628806)
                 )))

    ;; accum = Math.pow(t, 5);
    (set_local $accum (f32.mul (get_local $t) (get_local $accum)))
    (set_local $tau
      (f32.add
        (get_local $tau)
        (f32.mul (get_local $accum)
                   (f32.const 0.27886807)
                 )))

    ;; accum = Math.pow(t, 6);
    (set_local $accum (f32.mul (get_local $t) (get_local $accum)))
    (set_local $tau
      (f32.sub
        (get_local $tau)
        (f32.mul (get_local $accum)
                 (f32.const 1.13520398)
                 )))

    ;; accum = Math.pow(t, 7);
    (set_local $accum (f32.mul (get_local $t) (get_local $accum)))
    (set_local $tau
      (f32.add
        (get_local $tau)
        (f32.mul (get_local $accum)
               (f32.const 1.48851587)
                 )))

    ;; accum = Math.pow(t, 8);
    (set_local $accum (f32.mul (get_local $t) (get_local $accum)))
    (set_local $tau
      (f32.sub
        (get_local $tau)
        (f32.mul (get_local $accum)
             (f32.const 0.82215223)
                 )))

    ;; accum = Math.pow(t, 9);
    (set_local $accum (f32.mul (get_local $t) (get_local $accum)))
    (set_local $tau
      (f32.add
        (get_local $tau)
        (f32.mul (get_local $accum)
               (f32.const 0.17087277)
                 )))

    ;; (set_local $tau
    ;;   (f32.mul
    ;;     (get_local $t)
    ;;     (call $exp (get_local $tau))))
    (set_local $tau
        (call $exp (get_local $tau)))

    (if f32
      (f32.ge (get_local 0) (f32.const 0))
      (then
        (f32.sub (f32.const 1) (get_local $tau)))
      (else
        (f32.sub (get_local $tau) (f32.const 1)))
      )
    ))
