;;; (mpl util) — small helpers shared across the mpl libraries.
;;;
;;; `while` comes from upstream mpl util.sls. `equal-to` and `any-are`
;;; replace (dharmalab misc equivalence) and (dharmalab misc list).
;;; `mod` replaces R6RS `mod`, which mpl applies to exact rationals —
;;; R7RS floor-remainder only accepts integers.
(define-library (mpl util)
  (export while mod equal-to any-are)
  (import (scheme base)
          (srfi 1))
  (begin

    (define-syntax while
      (syntax-rules ()
        ((while test expr ...)
         (let loop ()
           (when test
             expr
             ...
             (loop))))))

    ;; R6RS mod for reals: x - y * floor(x/y)
    (define (mod x y)
      (- x (* y (floor (/ x y)))))

    (define (equal-to x)
      (lambda (y)
        (equal? x y)))

    (define (any-are pred)
      (lambda (lst)
        (any pred lst)))))
