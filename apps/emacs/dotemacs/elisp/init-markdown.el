(use-package
  markdown-mode
  :straight nil
  :mode ("\\.md\\'" . gfm-mode)
  :config
  ;; not sure why code blocks aren't highlighted by default
  (setq markdown-fontify-code-blocks-natively t)
  (setq markdown-command "multimarkdown"))

(provide 'init-markdown)
