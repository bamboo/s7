;;; implicit ref/set -- tmisc.scm and tread.scm also have some

(set! (*s7* 'heap-size) 1024000)
(load "s7test-block.so" (sublet (curlet) (cons 'init_func 'block_init)))

(define size 50000)

(define (s1 obj val)
  (set! (obj 'a) val))

(define (s11 obj val)
  (set! ((obj 'b) 'a) val))

(define (s111 obj val)
  (set! (obj 'b 'a) val))

(define (s1111 obj sym val)
  (set! (obj 'b sym) val))

(define (s11111 obj sym val)
  (set! (obj 'b (car sym)) val))


(define (s2 obj val)
  (set! (obj 'a) (+ (log 4 2) val)))

(define (s22 obj val)
  (set! ((obj 'b) 'a) (+ (log 4 2) val)))

(define (s222 obj val)
  (set! (obj 'b 'a) (+ (log 4 2) val)))

(define (s2222 obj sym val)
  (set! (obj 'b sym) (+ (log 4 2) val)))

(define (s22222 obj sym val)
  (set! (obj 'b (car sym)) (+ (log 4 2) val)))


(define (s3 obj val)
  (set! (obj 'b :a) val))


(define (s4 obj val)
  (set! (obj 'b 1) val))

(define (s44 obj val)
  (set! (obj 'b (- (log 4 2) 1)) val))

(define (s444 obj val)
  (set! (obj 'b 1) (car val)))

(define (s4444 obj ind val)
  (set! (obj 'b ind) val))


(define (s5 obj val)
  (set! (obj 0 1) val))

(define (s55 obj val)
  (set! (obj 0 (- (log 4 2) 1)) val))

(define (s555 obj val)
  (set! (obj 0 1) (car val)))

(define (s5555 obj ind val)
  (set! (obj 0 ind) val))


(define (s6 obj val)
  (set! (((obj 'b) 'b) 'a) val))

(define (s66 obj val)
  (set! (((obj 'b) 'b) 'a) val))

(define (s666 obj val)
  (set! (obj 'b 'b 'a) val))

(define (s6666 obj val)
  (set! ((obj 'b) 'b 'a) val))


(define (s7 obj val)
  (set! (list-ref (obj 0) 0) val))

(define (s77 obj i1 i2 val)
  (set! (list-ref (obj i1) i2) val))

(define (s777 obj val)
  (set! ((obj 0)) 32))


(define (s8 obj val)
  (set! (obj 0) val))

(define (s88 obj ind val)
  (set! (obj ind) val))

(define (s888 obj ind val)
  (set! (obj ind) (integer->char val)))

(define (s8888 obj ind val)
  (set! (obj (+ ind 1)) (integer->char val)))

(define (stest)
  (let ((table (hash-table 'a 1 'b (hash-table 'a 3)))
	(table1 (hash-table 'b "12345"))
	(table2 (vector (vector 1 2 3)))
	(table3 (hash-table 'b (block 1 2 3)))
	;; (table4 (hash-table 'b (let ((x (vector 1 2 3))) (dilambda (lambda (ind) (x ind)) (lambda (ind val) (set! (x ind) val))))))
	(table5 (hash-table 'a 1 'b (hash-table 'a 3 'b (hash-table 'a 4))))
	(table6 (vector (list 0 1) (list 2 3)))
	(env (inlet 'a 1 'b (inlet 'a 4)))
	(lst (list 0 1))
	(lst1 (list dilambda_test)) ; from s7test-block
	(lst2 (list (list 0 1)))
	(str "0123456789")
	(one 1))

    (do ((i 0 (+ i 1)))
	((= i size))

      (s1 table 12)
      (unless (= (table 'a) 12) (format *stderr* "[1]"))
      (s11 table 12)
      (unless (= ((table 'b) 'a) 12) (format *stderr* "[2]"))
      (s111 table 12)
      (unless (= (table 'b 'a) 12) (format *stderr* "[3]"))
      (s1111 table 'a 12)
      (unless (= (table 'b 'a) 12) (format *stderr* "[4]"))
      (s11111 table '(a) 12)
      (unless (= (table 'b 'a) 12) (format *stderr* "[5]"))

      (s1 env 12)
      (s11 env 12)
      (s111 env 12)
      (s1111 env 'a 12)
      (s11111 env '(a) 12)

      (s2 table 12)
      (unless (= (table 'a) 14) (format *stderr* "[6]"))
      (s22 table 12)
      (unless (= ((table 'b) 'a) 14) (format *stderr* "[7]"))
      (s222 table 12)
      (unless (= (table 'b 'a) 14) (format *stderr* "[8]"))
      (s2222 table 'a 12)
      (unless (= (table 'b 'a) 14) (format *stderr* "[9]"))
      (s22222 table '(a) 12)
      (unless (= (table 'b 'a) 14) (format *stderr* "[10]"))

      (s2 env 12)
      (s22 env 12)
      (s222 env 12)
      (s2222 env 'a 12)
      (s22222 env '(a) 12)

      (s3 env 32)
      (unless (= (env 'b 'a) 32) (format *stderr* "[11]"))

      (s4 table1 #\a) ; set_implicit_string
      (unless (char=? (table1 'b 1) #\a) (format *stderr* "[12]"))
      (s44 table1 #\a)
      (unless (char=? (table1 'b 1) #\a) (format *stderr* "[13]"))
      (s444 table1 '(#\a))
      (unless (char=? (table1 'b 1) #\a) (format *stderr* "[14]"))
      (s4444 table1 1 #\a)
      (unless (char=? (table1 'b 1) #\a) (format *stderr* "[15]"))

      (s4 table3 23.0) ; set_implicit_c_object
      (unless (= (table3 'b 1) 23.0) (format *stderr* "[16]"))
      (s44 table3 23.0)
      (unless (= (table3 'b 1) 23.0) (format *stderr* "[17]"))
      (s444 table3 '(23.0))
      (unless (= (table3 'b 1) 23.0) (format *stderr* "[18]"))
      (s4444 table3 1 23.0)
      (unless (= (table3 'b 1) 23.0) (format *stderr* "[19]"))

;      (s4 table4 23.0) ; set_implicit_closure -- now an error
;      (unless (= (table4 'b 1) 23.0) (format *stderr* "[20]"))
;      (s44 table4 23.0)
;      (unless (= (table4 'b 1) 23.0) (format *stderr* "[21]"))
;      (s444 table4 '(23.0))
;      (unless (= (table4 'b 1) 23.0) (format *stderr* "[22]"))
;      (s4444 table4 1 23.0)
;      (unless (= (table4 'b 1) 23.0) (format *stderr* "[23]"))

      (s5 table2 #\a) ; set_implicit_vector
      (unless (char=? (table2 0 1) #\a) (format *stderr* "[24]"))
      (s55 table2 #\a)
      (unless (char=? (table2 0 1) #\a) (format *stderr* "[25]"))
      (s555 table2 '(#\a))
      (unless (char=? (table2 0 1) #\a) (format *stderr* "[26]"))
      (s5555 table2 1 #\a)
      (unless (char=? (table2 0 1) #\a) (format *stderr* "[27]"))

      (s6 table5 12)
      (unless (= (((table5 'b) 'b) 'a) 12) (format *stderr* "[28]"))
      (s66 table5 12)
      (unless (= ((table5 'b) 'b 'a) 12) (format *stderr* "[29]"))
      (s666 table5 12)
      (unless (= (table5 'b 'b 'a) 12) (format *stderr* "[30]"))
      (s6666 table5 12)
      (unless (= (table5 'b 'b 'a) 12) (format *stderr* "[31]"))

      (s7 table6 12)
      (unless (= (table6 0 0) 12) (format *stderr* "[32]"))
      (s77 table6 0 1 12)
      (unless (= (table6 0 1) 12) (format *stderr* "[33]"))
      (s777 lst1 12)

      (s5 lst2 32)
      (unless (= (cadar lst2) 32) (format *stderr* "[34]"))
      (s55 lst2 12)
      (unless (= (cadar lst2) 12) (format *stderr* "[35]"))
      (s555 lst2 '(15))
      (unless (= (cadar lst2) 15) (format *stderr* "[36]"))
      (s5555 lst2 1 3)
      (unless (= (cadar lst2) 3) (format *stderr* "[37]"))

      (s8 str #\a)
      (unless (char=? (str 0) #\a) (format *stderr* "[38]"))
      (s88 str 1 #\b)
      (unless (char=? (str one) #\b) (format *stderr* "[39]"))
      (s888 str 2 (char->integer #\c))
      (unless (char=? (str (+ one 1)) #\c) (format *stderr* "[40]"))
      (s8888 str 2 (char->integer #\d))
      (unless (char=? (str 3) #\d) (format *stderr* "[41]"))
      (unless (string=? str "abcd456789") (format *stderr* "[42]"))

      )))

(stest)


(define len 1000000)

(define H (hash-table 'abs *))
(define (fabsH x)
  ((H 'abs) x 0.0001))

(define (f6) ; [719] -> [515 if func_one_arg handles hash] -> [508]
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (fabsH i))))))

(f6)


(define P (list + * -))
(define (fabsP x)
  ((P 1) x 0.0001))

(define (f8) ; [700] -> [524 fx_implicit]
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (fabsP i))))))

(f8)


(define V (vector + * -))
(define (fabsV x)
  ((V 1) x 0.0001))

(define (f9) ; [685] -> [512 fx_implicit]
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (fabsV i))))))

(f9)


(define C (make-cycle *))
(define (fabsC x)
  ((C) x 0.0001))

(define (f10) ; [681] (there is no op_implicit_c_object_ref)
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (fabsC i))))))

(f10)


;;; implicit arg cases (also included elsewhere)
(define B (block .001 .0001 .00001)) ; C-object as arg
(define (fabsB x)
  (* x (B 1)))

(define (f11) ; [591] no fx_*_ref?? block_ref_p_pp -> [519] fx_implicit_c_object_ref_a -- why not opt?
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (fabsB i))))))

(f11)


(define P2 (list (list + * -) (list .001 .0001 .00001)))
(define (fabsP2 x)
  ((P2 0 1) x 0.0001))

(define (f12) ; [797]
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (fabsP2 i))))))

(f12)


(define V2 #2d((#_+ #_* #_-) (.001 .0001 .00001)))
(define (fabsV2 x)
  ((V2 0 1) x 0.0001))

(define (f13) ; [778]
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (fabsV2 i))))))

(f13)


(define (f14) ; [492]
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (* i (P2 1 1)))))))

(f14)


(define (f15) ; [185] -- [738] if (vector (vector ...))
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (* i (V2 1 1)))))))

(f15)


(define H2 (hash-table 'a .0001))
(define (f16) ; [169] -- this is fully optimized!? -> [160] p_pp_sf_href!
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (* i (H2 'a)))))))

(f16)


(define L2 (inlet 'a .0001))
(define (f17) ; [173] (no lref) -> [167] lref -> [131 slot_ref]
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (* i (L2 'a)))))))

(f17)


(define V3 (vector .0001))
(define (f18) ; [148] (opt_p_pi_sc(t_vector_ref_p_pi_unchecked))
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (* i (V3 0)))))))

(f18)


(define P3 (list .0001))
(define (f19) ; [157] opt_p_pi_sc(list_ref_p_pi_unchecked)
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (* i (P3 0)))))))

(f19)


(define B3 (block .0001))
(define (f20) ; [114] d_7pi_sf(block_ref_d_7pi)
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (* i (B3 0)))))))

(f20)


(define V4 #2d((.0001)))
(define (f21) ; [185] opt_p_pii_sff(vector_ref_p_pii_direct)
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (* i (V4 0 0)))))))

(f21)


;;; let cases
(define L (inlet 'abs *))
(define L_abs (L 'abs))

(define (fabs x)
  ((L 'abs) x 0.0001))
  ;((if (integer? x) * /) x 0.0001))

(define (fLabs x)
  (L_abs x 0.0001))

(define (frefabs x)
  ((let-ref L 'abs) x 0.0001))


(define (f1) ; [729] -> [507 fx_implicit_let_ref_c]
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (fabs i))))))

(f1)


(define (f2) ; [298]
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (fLabs i))))))

(f2)


(define (f3) ; [510]
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (frefabs i))))))

(f3)


(define f4 ; [559]
  (let ((L (openlet (inlet '+ (lambda (arg obj)
				(#_+ arg (obj 'value)))
			   'value 3))))
    (lambda ()
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(unless (= (+ 1 L 2) 6)
	  (display "f4 oops\n"))))))

(f4)


(define (fabsL x)
  ((L 'abs) x 0.0001))

(define (f5) ; [512, 723 if set L to H in the loop, 693 if int *??] -> [503?]
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (fabsL i))))))

(f5)


(define (fabs:L x)
  ((L :abs) x 0.0001))

(define (f22) ; [721] -> [504] (added keyword check)
  (let ((sum 0.0))
    (do ((i 0 (+ i 1)))
	((= i len) sum)
      (set! sum (+ sum (fabs:L i))))))

(f22)


(exit)
