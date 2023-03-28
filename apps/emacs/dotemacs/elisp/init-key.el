(define-minor-mode dot/keys-mode
  "Dotfiles driven keymap"
  :global t
  :keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-j") 'windmove-down)
    (define-key map (kbd "M-k") 'windmove-up)
    (define-key map (kbd "M-h") 'windmove-left)
    (define-key map (kbd "M-l") 'windmove-right)
    (define-key map (kbd "M-S-<return>") 'split-window-right)
    (define-key map (kbd "M-C") 'delete-window)
    map))

(dot/keys-mode t)

(provide 'init-key)
