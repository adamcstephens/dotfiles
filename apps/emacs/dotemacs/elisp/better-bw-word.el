;;; better-bw-word.el --- summary -*- lexical-binding: t -*-

;; Author: Nathan Nichols
;; Maintainer: Nathan Nichols
;; Version: 1.0
;; Package-Requires: mwim
;; Homepage: http://chud.wtf
;; Keywords: movement

;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Provides alternatives to `forward-word', `backward-word',
;; `backward-kill-word', `forward-kill-word' that are generally less
;; greedy, especially when the backward word contains a newline.

;; commentary

;;; Code:

(require 'mwim)

;; This is useful for blocks of whitespace that
(defun nate/kill-backward-whitespace ()
  "Kill block of whitespace before point.
Useful for killing blocks of whitespace that are within a single line."
  (interactive "*")
  (delete-region
    (point)
    (progn
      (skip-chars-backward " \t\r\n\v\f")
      (point))))

(defun nate/get-forward-region (&optional arg)
  "Return the region between point before  `forward-word'.
`ARG' is argument passed to `forward-word'."
  (interactive)
  (let*
    (
      (p1 (point))
      ;; Note: backward-word is really a lisp wrapper around forward-word (which is a C function.)
      (temp (forward-word arg))
      (p2 (point))
      (forward-region (buffer-substring-no-properties p1 p2)))
    ;; backward-region = the region that we would have jumped over with backward-word
    (goto-char p1)
    forward-region))

(defun nate/get-backward-region (&optional arg)
  "Return the region between point and where it would be after calling `backward-word' `ARG'."
  (interactive)
  (nate/get-forward-region (- (or arg 1))))

(defun get-curr-line ()
  "Return current line as a string."
  (buffer-substring (line-beginning-position) (line-end-position)))

(defun nate/looking-bidi (regexp dir)
  (cond
    ((> dir 0)
      (looking-back regexp nil))
    ((< dir 0)
      (looking-at regexp))))

(defun nate/mwim-bidi (dir)
  (cond
    ((> dir 0)
      (mwim-end))
    ((< dir 0)
      (mwim-beginning))))

(defun nate/skip-chars-bidi (chars dir)
  (cond
    ((> 0 dir)
      (skip-chars-forward " \t\r\n\v\f"))
    ((< 0 dir)
      (skip-chars-backward " \t\r\n\v\f"))))

(defun nate/skip-whitespace-block (&optional arg)
  "Move point before whitespace."
  (let ((arg (or arg 1)))
    (nate/skip-chars-bidi " \t\r\n\v\f" arg)))

(defun nate/walk-back-line (&optional arg)
  "Move to the mwim-end of the last non-whitespace line before current line."
  (forward-line (- arg))
  (nate/mwim-bidi arg)
  (if (string-match-p (get-curr-line) "\s+")
    (nate/skip-whitespace-block arg)))

(defun nate/backward-word (&optional arg)
  "Make `backward-word' less greedy when moving across lines."
  (interactive "^p") ;; ^ = handle marker/region correctly
  (let*
    (
      (arg (or arg 1))
      (bw-region (nate/get-backward-region arg)))
    (cond ;; First, see if there is just whitespace ahead of the point.
      ((nate/looking-bidi "\s*\n+\s*" arg)
        (nate/skip-whitespace-block arg))

      ;; If not on whitepace but still deleting across lines, move to the
      ;; mwim-start/end of the last non-whitespace line before current line.
      ((string-match-p "\n" bw-region)
        (nate/walk-back-line arg))
      ;; If here, just do backward word because the point will
      ;; stay within the same line as it started.
      (t
        (backward-word arg))))
  (point))

(defun nate/forward-word (&optional arg)
  (interactive "^") ;; ^ = handle marker/region correctly
  (nate/backward-word -1))

;;

;;!
;; TEST CASE: put point on the above "!" and do nate/backward-word. See if it works correctly.

(defun nate/backward-kill-word (arg)
  "Like `backward-kill-word' but less greedy."
  (interactive "*p")
  (delete-region (point) (nate/backward-word)))

(defun nate/forward-line ()
  (interactive "^")
  (forward-line 1)
  (mwim-end))

(defun nate/backward-line ()
  (interactive "^")
  (forward-line -1)
  (mwim-end))

(provide 'better-bw-word)

;;; better-bw-word.el ends here
