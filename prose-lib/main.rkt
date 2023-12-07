#lang racket/base
; SPDX-License-Identifier: BlueOak-1.0.0
; This file is licensed under the Blue Oak Model License 1.0.0.

;; Reader and indenter/color lexer for #lang prose

(module reader racket/base
  (require "private/constants.rkt"
           "private/reader-utils.rkt"
           scribble/reader
           syntax/strip-context)
  (provide get-info (rename-out [*read-syntax read-syntax]))

  (define read-prose-syntax
    (make-at-reader #:command-char prose-command-char
                    #:syntax? #t
                    #:inside? #t))
  
  (define (*read-syntax name inport)
    (port-count-lines! inport)
    (define source-path
      (format "~a" ((if (syntax? name) syntax-source values) name)))
    (define extra-modules (read-line-modpaths name inport))
    (define meta-kvs
      `(',prose-here-path-key ,source-path ,@(or (read-metas-block name inport) '())))
    (define exprs (read-prose-syntax name inport))

    (strip-context
     #`(module runtime-wrapper racket/base
         (module configure-runtime racket/base
           (require prose/private/configure-runtime)
           (current-top-path #,source-path))
         (module _prose-main prose/private/main
           #,meta-kvs
           #,extra-modules
           #,@exprs)
         (require '_prose-main (only-in prose/private/configure-runtime show))
         (provide (all-from-out '_prose-main))
         (show #,prose-doc-id #,source-path))))
  
  (define (get-info port src-mod src-line src-col src-pos)
    (λ (key default)
      (case key
        [(color-lexer)
         (define maybe-lexer
           (dynamic-require 'syntax-color/scribble-lexer 'make-scribble-inside-lexer (λ () #false)))
         (cond
           [(procedure? maybe-lexer) (maybe-lexer #:command-char prose-command-char)]
           [else default])]
        [(drracket:indentation)
         (with-handlers ([exn:missing-module?
                        (λ (x) (default key default))])
           (dynamic-require 'scribble/private/indentation 'determine-spaces))]
        [else default]))))
