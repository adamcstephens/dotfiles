(use-package which-key
  :init
  (which-key-mode))

(global-set-key (kbd "C-_") 'comment-or-uncomment-region)
(global-set-key (kbd "C-r") 'undo-redo)

(provide 'init-key)
