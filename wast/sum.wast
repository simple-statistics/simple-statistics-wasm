(module
  ;; TODO: this recursive exp implementation is from
  ;; https://stackoverflow.com/questions/3518973/floating-point-exponentiation-without-power-function
  ;; but it doesn't work yet.
  (func $sqr
	(param f32)
	(result f32)
	(f32.mul
	  (get_local 0)
	  (get_local 0)))
  (func $pow
	;; base, power, precision
	(param f32 f32 f32)
	(result f32)
	;; power <= 0
	(if
	  (f32.lt
	    (get_local 1)
	    (f32.const 0))
	  (then 
	    (return 
	      (f32.div
		(f32.const 1)
		(call $pow
		  (get_local 0)
		  (f32.mul (f32.const -1) (get_local 1))
		  (get_local 1))))))
	;; power >= 10
	(if
	  (f32.ge
	    (get_local 1)
	    (f32.const 10))
	  (then 
	    (return 
	      (call $sqr
		(call $pow
		  (get_local 0)
		  (f32.div
		    (get_local 1)
		    (f32.const 2))
		  (f32.div
		    (get_local 2)
		    (f32.const 2)))))))
	;; power >= 1
	(if
	  (f32.ge
	    (get_local 1)
	    (f32.const 1))
	  (then 
	    (return 
	      (f32.mul
		(get_local 0)
		(call $pow
		  (get_local 0)
		  (f32.sub
		    (get_local 1)
		    (f32.const 1))
		  (get_local 2))))))
	;; precision >= 1
	(if
	  (f32.ge
	    (get_local 2)
	    (f32.const 1))
	  (then 
	    (return 
	      (f32.sqrt (get_local 0)))))
	(f32.sqrt
	  (call $pow
	    (get_local 0)
	    (f32.mul
	      (get_local 1)
	      (f32.const 2))
	    (f32.mul
	      (get_local 2)
	      (f32.const 2)))))
  (func $exp
	(param f32)
	(result f32)
	(call $pow
	  (f32.const 2.718281828459045)
	  (get_local 0)
	  (f32.const 0.001)))
  (func (export "f")
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
    (set_local $tau
	       ;; waiting on math.exp here, but
	       ;; t * -(x * x)
	       (f32.mul
		 (get_local $t)
		 (call $exp
		   (f32.add
		     (f32.add
		       (f32.add
			 (f32.add
			   (f32.add
			     (f32.add
			       (f32.add
				 (f32.add
				   (f32.add
				     (f32.sub
				       (f32.mul (f32.const -1) (f32.mul ;; x * x
					 (get_local 0)
					 (get_local 0)))
				       (f32.const 1.26551223))
				     ;; L21
				     (f32.mul
				       (get_local 0)
				       (f32.const 1.00002368)))
				   ;; L22
				   (f32.mul
				     (f32.const 0.37409196)
				     (tee_local $accum (f32.mul
							 (get_local $t)
							 (get_local $accum)))))
				 ;; L23
				 (f32.mul
				   (f32.const 0.09678418)
				   (tee_local $accum (f32.mul
						       (get_local $t)
						       (get_local $accum)))))
			       ;; L24
			       (f32.mul
				 (f32.const 0.18628806)
				 (tee_local $accum (f32.mul
						     (get_local $t)
						     (get_local $accum)))))
			     ;; L25
			     (f32.mul
			       (f32.const 0.27886807)
			       (tee_local $accum (f32.mul
						   (get_local $t)
						   (get_local $accum)))))
			   ;; L26
			   (f32.mul
			     (f32.const 1.13520398)
			     (tee_local $accum (f32.mul
						 (get_local $t)
						 (get_local $accum)))))
			 ;; L27
			 (f32.mul
			   (f32.const 1.48851587)
			   (tee_local $accum (f32.mul
					       (get_local $t)
					       (get_local $accum)))))
		       ;; L28
		       (f32.mul
			 (f32.const 0.82215223)
			 (tee_local $accum (f32.mul
					     (get_local $t)
					     (get_local $accum)))))
		     ;; L29
		     (f32.mul
		       (f32.const 0.17087277)
		       (tee_local $accum (f32.mul
					   (get_local $t)
					   (get_local $accum)))))
		  )))


    (if f32
      (f32.ge (get_local 0) (f32.const 0))
      (then
	(f32.sub (f32.const 1) (get_local $tau)))
      (else
	(f32.sub (get_local $tau) (f32.const 1)))
      )))
