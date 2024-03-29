(defun dot/freeze ()
  (interactive)
  (straight-freeze-versions t))

(defun dot/update ()
  "Update and freeze all packages"
  (interactive)
  (straight-pull-recipe-repositories)
  (straight-pull-all)
  (straight-rebuild-all)
  (dot/freeze)
  (dot/clean))

(defun dot/thaw ()
  "Thaw pinned straight packages and check them"
  (interactive)
  (straight-thaw-versions)
  (dot/clean))

(defun dot/clean ()
  (straight-remove-unused-repos t)
  (straight-prune-build)
  (straight-check-all))

(defun dot/uuid ()
  (interactive)
  (insert
    (downcase
      (replace-regexp-in-string
        "\n$"
        ""
        (shell-command-to-string "uuidgen")))))

(provide 'init-lib)
