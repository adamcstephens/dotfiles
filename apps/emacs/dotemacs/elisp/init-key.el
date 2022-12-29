(use-package which-key
  :init
  (which-key-mode))

(global-set-key (kbd "C-_") 'comment-or-uncomment-region)
(global-set-key (kbd "C-c f s") 'save-buffer)
(global-set-key (kbd "C-r") 'undo-redo)

(define-key minibuffer-local-map (kbd "C-j") 'next-line)
(define-key minibuffer-local-map (kbd "C-k") 'previous-line)

(use-package move-text
  :init
  (move-text-default-bindings))

(provide 'init-key)
