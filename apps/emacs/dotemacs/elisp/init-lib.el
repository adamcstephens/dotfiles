(defun dot/uuid ()
  (interactive)
  (insert
    (downcase
      (replace-regexp-in-string
        "\n$"
        ""
        (shell-command-to-string "uuidgen")))))

(provide 'init-lib)
