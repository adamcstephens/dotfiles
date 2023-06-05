(define-minor-mode dot/keys-mode
  "Dotfiles driven keymap"
  :global t
  :keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-J") 'windmove-down)
    (define-key map (kbd "M-K") 'windmove-up)
    (define-key map (kbd "M-H") 'windmove-left)
    (define-key map (kbd "M-L") 'windmove-right)
    (define-key map (kbd "M-S-<return>") 'split-window-right)
    (define-key map (kbd "M-C") 'delete-window)
    map))

(dot/keys-mode t)

(provide 'init-key)
