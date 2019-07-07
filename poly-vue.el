;;; poly-vue.el --- Polymode for Vue files -*- lexical-binding: t -*-

;; Copyright (C) 2019 Akira Komamura
;; Author: Akira Komamura
;; Version: 0.1
;; Package-Requires: ((emacs "25") (polymode "0.2"))
;; Keywords: languages, multi-modes
;; URL: https://github.com/akirak/poly-vue

;; This file is not part of GNU Emacs.

;;; License:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;
;; This library adds poly-mode <https://github.com/polymode/polymode>
;; support for Vue files.
;;

;;; Code:

(require 'polymode)

(defconst poly-vue-generic-head-regexp
  (rx bol "<%s"
      (? (and (+ space)
              "lang="
              (any "\"'")
              (group (+ (any alpha)))
              (any "\"'")))
      (* space)
      ">" eol))

(defconst poly-vue-template-head-regexp
  (format poly-vue-generic-head-regexp "template"))

(defconst poly-vue-script-head-regexp
  (format poly-vue-generic-head-regexp "script"))

(defconst poly-vue-style-head-regexp
  (rx bol "<style"
      (* (and space (or "scoped"
                        "module"
                        (and (+ (any wordchar))
                             "="
                             (any "\"'")
                             (*? anything)
                             (any "\"'")))))
      (and (+ space)
           "lang="
           (any "\"'")
           (group (+ (any alpha)))
           (any "\"'"))
      (* (and space (or "scoped"
                        "module"
                        (and (+ (any wordchar))
                             "="
                             (any "\"'")
                             (*? anything)
                             (any "\"'")))))
      (* space)
      ">" eol))

(defcustom poly-vue-template-languages
  '(("html" . vue-html-mode))
  "Alist of language names and major modes supported in templates."
  :type '(alist :key-type string
                :value-type symbol)
  :group 'poly-vue)

(defcustom poly-vue-script-languages
  '(("ts" . typescript-mode))
  "Alist of language names and major modes supported in scripts."
  :type '(alist :key-type string
                :value-type symbol)
  :group 'poly-vue)

(defcustom poly-vue-style-languages
  '(("scss" . scss-mode))
  "Alist of language names and major modes supported in stylesheets."
  :type '(alist :key-type string
                :value-type symbol)
  :group 'poly-vue)

(define-hostmode poly-vue-hostmode
  :mode 'sgml-mode
  :protect-syntax nil
  :protect-font-lock nil)

(defun poly-vue-template-mode-matcher ()
  "Matcher for the template tag in Vue files."
  (when (re-search-forward poly-vue-template-head-regexp (point-at-eol) t)
    (let ((lang (match-string-no-properties 1)))
      (or (cdr (assoc lang poly-vue-template-languages))
          lang))))

(defun poly-vue-script-mode-matcher ()
  "Matcher for the script tag in Vue files."
  (when (re-search-forward poly-vue-script-head-regexp (point-at-eol) t)
    (let ((lang (match-string-no-properties 1)))
      (or (cdr (assoc lang poly-vue-script-languages))
          lang))))

(defun poly-vue-style-mode-matcher ()
  "Matcher for the style tag in Vue files."
  (when (re-search-forward poly-vue-style-head-regexp (point-at-eol) t)
    (let ((lang (match-string-no-properties 1)))
      (or (cdr (assoc lang poly-vue-style-languages))
          lang))))

(define-auto-innermode poly-vue-template-innermode
  :fallback-mode 'vue-html-mode
  :head-mode 'host
  :tail-mode 'host
  :head-matcher "^<template.*?>\n"
  :tail-matcher "^</template>"
  :mode-matcher #'poly-vue-template-mode-matcher
  :body-indent-offset 'vue-html-extra-indent)

(define-auto-innermode poly-vue-script-innermode
  :fallback-mode 'js2-mode
  :head-mode 'host
  :tail-mode 'host
  :head-matcher "^<script.*?>\n"
  :tail-matcher "^</script>"
  :mode-matcher #'poly-vue-script-mode-matcher
  :body-indent-offset 0)

(define-auto-innermode poly-vue-style-innermode
  :fallback-mode 'css-mode
  :head-mode 'host
  :tail-mode 'host
  :head-matcher "^<style.*?>\n"
  :tail-matcher "^</style>"
  :mode-matcher #'poly-vue-style-mode-matcher
  :body-indent-offset 0)

;;;###autoload  (autoload 'poly-vue-mode "poly-vue")
(define-polymode poly-vue-mode
  :hostmode 'poly-vue-hostmode
  :innermodes '(poly-vue-template-innermode
                poly-vue-script-innermode
                poly-vue-style-innermode))

 ;;;###autoload
(add-to-list 'auto-mode-alist '("\\.vue\\'" . poly-vue-mode))

(provide 'poly-vue)
;;; poly-vue.el ends here
