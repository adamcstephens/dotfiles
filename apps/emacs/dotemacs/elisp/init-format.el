(use-package format-all
  :config (progn
	    (add-hook 'prog-mode-hook 'format-all-mode)
	    (add-hook 'prog-mode-hook 'format-all-ensure-formatter)
	    )
  )

(provide 'init-format)
