;; discover shortcuts easier in the minibuffer
(use-package which-key
  :init
  (which-key-mode))

;; moving lines up and down can be handy
(use-package move-text
  :init
  (move-text-default-bindings))

(global-set-key (kbd "C-_") 'comment-or-uncomment-region)
(global-set-key (kbd "C-c f s") 'save-buffer)
(global-set-key (kbd "C-r") 'undo-redo)

(define-key minibuffer-local-map (kbd "C-j") 'next-line)
(define-key minibuffer-local-map (kbd "C-k") 'previous-line)
(define-key minibuffer-local-map (kbd "C-u") 'kill-whole-line)
(define-key minibuffer-local-map (kbd "C-<backspace>") 'backward-kill-word)

(provide 'init-key)
