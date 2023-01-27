(defun dot/freeze ()
  (interactive)
  (straight-freeze-versions t))

(defun dot/update ()
  "Update and freeze all packages"
  (interactive)
  (straight-pull-recipe-repositories)
  (straight-pull-all)
  (dot/freeze))

(defun dot/uuid ()
  (interactive)
  (insert
    (downcase
      (replace-regexp-in-string
        "\n$"
        ""
        (shell-command-to-string "uuidgen")))))

(provide 'init-lib)
