;; kill-with-intelligence.el --- Making buffer killing suck less. -*- lexical-binding: t -*-
;;
;; Source: https://christiantietze.de/posts/2023/09/kill-unsaved-buffer-ux-action-labels/
;;
;;; Commentary:
;; Original function at the time of this writing is at:
;; https://github.com/emacs-mirror/emacs/blob/3907c884f03cf5f2a09696bda015b1060c7111ba/lisp/simple.el#L10980
;;
;;; Code:

(defun ct/kill-buffer--possibly-save--advice (original-function &rest args)
  "Ask user in the minibuffer whether to save before killing.

Replaces `kill-buffer--possibly-save' as advice, so
ORIGINAL-FUNCTION is unused and never delegated to. Its first
parameter is the buffer, which is the `car' or ARGS."
  (let ((buffer (car args))
         (response
           (car
             (read-multiple-choice
               (format "Buffer %s modified."
                 (buffer-name))
               '((?s "Save and kill buffer" "save the buffer and then kill it")
                  (?d "Discard and kill buffer without saving" "kill buffer without saving")
                  (?c "Cancel" "Exit without doing anything"))
               nil nil (and (not use-short-answers)
                         (not (use-dialog-box-p)))))))
    (cond ((equal response ?s)
            (progn
              (with-current-buffer buffer
                (save-buffer))
              t))
      ((equal response ?d)
        t)
      ((equal response ?c)
        nil)
      )))


(advice-add 'kill-buffer--possibly-save :around #'ct/kill-buffer--possibly-save--advice)

;;;

(provide 'kill-with-intelligence)
