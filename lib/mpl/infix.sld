;;; (mpl infix) — infix expression parser: (alg "a x^2 + b") => '(+ (* a (^ x 2)) b)
;;;
;;; Replaces (dharmalab infix alg). The shunting-yard `infix` procedure
;;; is ported from dharmalab infix/infix.sls (Apache-2.0, Eduardo
;;; Cavazos); the silex-generated tokenizer is replaced by a small
;;; hand-written one implementing the same token rules (see
;;; dharmalab infix/calculator.l):
;;;   - decimal integers and reals (with optional exponent)
;;;   - operators + - * / % ^ \ = as symbols
;;;   - identifiers: initial [a-zA-Z!$&:<>?_~], subsequent adds [0-9.@]
;;;   - #\( #\) #\, as characters; whitespace skipped
(define-library (mpl infix)
  (export alg string->infix infix)
  (import (scheme base)
          (scheme char)
          (srfi 1))
  (begin

    ;; ------------------------------------------------------------------
    ;; Tokenizer
    ;; ------------------------------------------------------------------

    (define (initial-char? c)
      (or (char-alphabetic? c)
          (memv c '(#\! #\$ #\& #\: #\< #\> #\? #\_ #\~))))

    (define (subsequent-char? c)
      (or (initial-char? c)
          (char-numeric? c)
          (memv c '(#\. #\@))))

    (define (operator-char? c)
      (memv c '(#\+ #\- #\* #\/ #\% #\^ #\\ #\=)))

    (define (tokenize str)
      (let ((len (string-length str)))

        (define (number-end i)
          ;; i points at a digit; scan digits [. digits] [e[+-]digits]
          (let* ((j (scan-digits i))
                 (j (if (and (< j len) (char=? (string-ref str j) #\.))
                        (scan-digits (+ j 1))
                        j)))
            (if (and (< j len) (memv (string-ref str j) '(#\e #\E))
                     (let ((k (if (and (< (+ j 1) len)
                                       (memv (string-ref str (+ j 1)) '(#\+ #\-)))
                                  (+ j 2)
                                  (+ j 1))))
                       (and (< k len) (char-numeric? (string-ref str k)))))
                (scan-digits
                 (if (memv (string-ref str (+ j 1)) '(#\+ #\-)) (+ j 2) (+ j 1)))
                j)))

        (define (scan-digits i)
          (if (and (< i len) (char-numeric? (string-ref str i)))
              (scan-digits (+ i 1))
              i))

        (define (symbol-end i)
          (if (and (< i len) (subsequent-char? (string-ref str i)))
              (symbol-end (+ i 1))
              i))

        (let loop ((i 0) (acc '()))
          (if (>= i len)
              (reverse acc)
              (let ((c (string-ref str i)))
                (cond
                  ((or (char-whitespace? c))
                   (loop (+ i 1) acc))
                  ((char-numeric? c)
                   (let ((j (number-end i)))
                     ;; imaginary literal: digits immediately followed by i,
                     ;; e.g. "4i" => +4i (see dharmalab calculator.l {imag})
                     (if (and (< j len) (char=? (string-ref str j) #\i))
                         (loop (+ j 1)
                               (cons (string->number
                                      (string-append "+" (substring str i (+ j 1))))
                                     acc))
                         (loop j (cons (string->number (substring str i j)) acc)))))
                  ((operator-char? c)
                   (loop (+ i 1) (cons (string->symbol (string c)) acc)))
                  ((initial-char? c)
                   (let ((j (symbol-end i)))
                     (loop j (cons (string->symbol (substring str i j)) acc))))
                  ((memv c '(#\( #\) #\,))
                   (loop (+ i 1) (cons c acc)))
                  (else
                   (error "alg: unexpected character" c str))))))))

    ;; Group parenthesized token runs into nested lists, as dharmalab's
    ;; string->infix did with its streaming lexer.
    (define (group-tokens tokens)
      ;; returns (values grouped-list remaining-tokens)
      (let loop ((tokens tokens) (acc '()))
        (cond
          ((null? tokens)
           (values (reverse acc) '()))
          ((eqv? (car tokens) #\()
           (let-values (((inner rest) (loop (cdr tokens) '())))
             (loop rest (cons inner acc))))
          ((eqv? (car tokens) #\))
           (values (reverse acc) (cdr tokens)))
          (else
           (loop (cdr tokens) (cons (car tokens) acc))))))

    (define (string->infix str)
      (let-values (((grouped rest) (group-tokens (tokenize str))))
        grouped))

    ;; ------------------------------------------------------------------
    ;; Shunting-yard: flat infix list -> prefix s-expression
    ;; ------------------------------------------------------------------

    (define precedence-table
      '((sentinel . 0)
        (=        . 1)
        (+        . 2)
        (-        . 2)
        (*        . 4)
        (/        . 4)
        (^        . 5)))

    (define (precedence item)
      (let ((result (assq item precedence-table)))
        (if result
            (cdr result)
            100)))

    (define (right-associative? obj)
      (member obj '(^)))

    (define operators (cdr (map car precedence-table)))

    (define (operator? obj)
      (member obj operators))

    (define (args->operands expr)
      (if (null? expr)
          '()
          (let ((i (list-index (lambda (x) (eqv? x #\,)) expr)))
            (if i
                (cons (infix (take expr i))
                      (args->operands (drop expr (+ i 1))))
                (list (infix expr))))))

    (define (shunting-yard expr operands operators)

      (define (rewrite-unaries expr)
        (if (and (operator? (list-ref expr 0))
                 (operator? (list-ref expr 1)))
            (list (list-ref expr 0)
                  (cdr expr))
            expr))

      (define (check-for-mul expr)
        (if (and (>= (length expr) 2)
                 (not (operator? (list-ref expr 0)))
                 (not (operator? (list-ref expr 1)))
                 (not (list? (list-ref expr 1))))
            (cons (car expr)
                  (cons '* (cdr expr)))
            expr))

      (define (apply-operator)
        (cond ((and (operator? (car operators))
                    (= (length operands) 1))
               (shunting-yard expr
                              (cons (list (car operators)
                                          (list-ref operands 0))
                                    (cdr operands))
                              (cdr operators)))
              ((operator? (car operators))
               (shunting-yard expr
                              (cons (list (car operators)
                                          (list-ref operands 1)
                                          (list-ref operands 0))
                                    (cdr (cdr operands)))
                              (cdr operators)))
              (else
               (shunting-yard expr
                              (cons (list (car operators)
                                          (list-ref operands 0))
                                    (cdr operands))
                              (cdr operators)))))

      (if (null? expr)

          (if (eq? (car operators) 'sentinel)
              (car operands)
              (apply-operator))

          (let ((expr (check-for-mul (rewrite-unaries expr))))

            (let ((elt (car expr)))

              (cond ((operator? elt)
                     (if (or (> (precedence elt)
                                (precedence (car operators)))
                             (and (right-associative? elt)
                                  (= (precedence elt)
                                     (precedence (car operators)))))
                         (shunting-yard (cdr expr) operands (cons elt operators))
                         (apply-operator)))

                    ;; f(x) / f(x,y,z)
                    ((and (>= (length expr) 2)
                          (list? (list-ref expr 1)))
                     (shunting-yard (cdr (cdr expr))
                                    (cons (cons elt
                                                (args->operands (list-ref expr 1)))
                                          operands)
                                    operators))

                    ((list? elt)
                     (shunting-yard (cdr expr)
                                    (cons (infix elt) operands)
                                    operators))

                    (else
                     (shunting-yard (cdr expr) (cons elt operands) operators)))))))

    (define (infix expr)
      (shunting-yard expr '() (circular-list 'sentinel)))

    (define (alg str)
      (infix (string->infix str)))))
