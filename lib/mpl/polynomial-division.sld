;;; (mpl polynomial-division) — monomial-based polynomial division.
;;; Exports quotient and remainder, shadowing the (scheme base) integer
;;; procedures — importers must except quotient/remainder from base.
(define-library (mpl polynomial-division)
  (export polynomial-division quotient remainder)
  (import (except (scheme base) + - * / numerator denominator quotient remainder)
          (mpl arithmetic)
          (mpl util)
          (mpl degree-gpe)
          (mpl algebraic-expand)
          (mpl leading-coefficient-gpe))
  (begin

    (define (polynomial-division u v x)
      (let* ((q 0)
             (r u)
             (m (degree-gpe r (list x)))
             (n (degree-gpe v (list x)))
             (lcv (leading-coefficient-gpe v x)))
        (while (and (>= m n)
                    (not (equal? r 0))) ;; see footnote 2 page 115
          (let* ((lcr (leading-coefficient-gpe r x))
                 (s (/ lcr lcv)))
            (set! q (+ q (* s (^ x (- m n)))))
            (set! r (algebraic-expand (- (- r (* lcr (^ x m)))
                                         (* (- v (* lcv (^ x n)))
                                            s
                                            (^ x (- m n))))))
            (set! m (degree-gpe r (list x)))))
        (list q r)))

    (define (quotient u v x)
      (list-ref (polynomial-division u v x) 0))

    (define (remainder u v x)
      (list-ref (polynomial-division u v x) 1))))
