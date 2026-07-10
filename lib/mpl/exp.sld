;;; (mpl exp) — symbolic exponential.
(define-library (mpl exp)
  (export exp)
  (import (scheme base)
          (rename (only (scheme inexact) exp) (exp rnrs:exp)))
  (begin

    (define (exp u)
      (cond
        ;; R6RS exp returns exact 1 for exact 0 (contract-exp relies on
        ;; the 1 simplifying away); Kaappi's exp returns inexact 1.0.
        ((eqv? u 0) 1)
        ((number? u) (rnrs:exp u))
        (else `(exp ,u))))))
