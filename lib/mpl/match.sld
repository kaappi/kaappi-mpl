;;; (mpl match) — portable hygienic pattern matcher.
;;;
;;; Alex Shinn's syntax-rules match (public domain), vendored from
;;; chibi-scheme lib/chibi/match/match.scm. The upstream mpl used the
;;; R6RS syntax-case adaptation of the same matcher; this is the R7RS
;;; original, so match semantics are identical.
(define-library (mpl match)
  (export match match-let match-let* match-letrec
          match-lambda match-lambda*)
  (import (scheme base))
  (include "match-impl.scm"))
