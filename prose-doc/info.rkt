#lang info

(define collection "prose")
(define scribblings '(("prose.scrbl")))

(define deps '("scribble-lib"
               "base"))
(define build-deps '("commonmark-doc"
                     "commonmark-lib"
                     "racket-doc"
                     "scribble-doc"
                     "prose-lib"))

(define update-implies '("prose-lib"))

(define pkg-desc "documentation part of \"prose\"")
(define license 'BlueOak-1.0.0)
