;; double fract;
;; double temp1, temp2, xsq;
;; int ent;

;; temp2 = ((1.0*xsq+q2)*xsq+q1)*xsq + q0;
;; return(ldexp(sqrt2*(temp2+temp1)/(temp2-temp1), ent));


(module
  (func (export "exp")
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

    ;; if(arg == 0.)
    ;;  return(1.);
    (if f32 (f32.eq (get_local 0) (f32.const 0))
      (then (f32.const 1))
    ;; if(arg < -maxf)
    ;;  return(0.);
    (else (if f32 (f32.lt (get_local 0) (f32.mul (f32.const -1) (get_local $maxf)))
      (then (f32.const 0))
    ;; if(arg > maxf) {
    ;;  errno = ERANGE;
    ;;  return(HUGE);
    ;; }
    (else (if f32 (f32.gt (get_local 0) (get_local $maxf))
      (then (f32.const -1)) ;; TODO: throw error
    (else
      ;; arg *= log2e;
      (set_local 0 (f32.mul (get_local 0) (get_local $log2e)))
      ;; ent = floor(arg);
      (set_local $ent (f32.trunc (get_local 0)))
      ;; fract = (arg-ent) - 0.5;
      (set_local $fract
	(f32.sub
		    (f32.sub
		      (get_local 0)
		      (get_local $ent)) (f32.const 0.5)))
      ;; xsq = fract*fract;
      (set_local $xsq (f32.mul (get_local $fract) (get_local $fract)))
      ;; temp1 = ((p2*xsq+p1)*xsq+p0)*fract;
      (set_local $temp1
	;; (((xsq * p2 + xsq) * xsq) + p0) * fract
	(f32.mul
	  (get_local $fract
	  ;; ((xsq * p2 + xsq) * xsq) + p0
	  (f32.add
	    (get_local $p0)
	    ;; (((xsq * p2) + p1) * xsq)
	    (f32.mul
	      (get_local $xsq)
	      ;; ((xsq * p2) + p1)
	      (f32.add
		(get_local $p1)
		;; (xsq * p2)
		(f32.mul (get_local $xsq) (get_local $p2))))))))

      (set_local $temp2
    	 ;; ((1.0*xsq+q2)*xsq+q1)*xsq + q0;
	(f32.add
	  (get_local $q0)
	  (f32.mul
	    (get_local $xsq
	    ;; (((xsq * 1.0) + q2) * xsq)
	    (f32.add
	      (get_local $q1)
	      ;; (((xsq * 1.0) + q2) * xsq)
	      (f32.mul
		(get_local $xsq)
		;; ((xsq * 1.0) + q2)
		(f32.add
		  (get_local $q2)
		  ;; (1.0 * xsq)
		  (f32.mul (get_local $xsq) (f32.const 0)))))))))



      ;; return(ldexp(sqrt2*(temp2+temp1)/(temp2-temp1), ent));


      (return (f32.mul
	(f32.div
	  (f32.mul
	    (get_local $sqrt2)
	    (f32.add
	      (get_local $temp1)
	      (get_local $temp2)))
	  (f32.sub
	    (get_local $temp1)
	    (get_local $temp2)))
	(f32.convert_s/i32 (i32.shl (i32.const 2) (i32.trunc_s/f32 (get_local $ent))))))
 ))))))))
