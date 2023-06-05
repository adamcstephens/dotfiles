(defun dot/deno-project-p ()
  "Predicate for determining if the open project is a Deno one."
  (let ((p-root (doom-modeline-project-root)))
    (file-exists-p (concat p-root "deno.jsonc"))))

(defun dot/node-project-p ()
  "Predicate for determining if the open project is a Node one."
  (let ((p-root (doom-modeline-project-root)))
    (file-exists-p (concat p-root "package.json"))))

(defun dot/ecma-server-program (_)
  "Decide which server to use for ECMA Script based on project characteristics."
  (cond
    ((dot/deno-project-p)
      '("deno" "lsp" :initializationOptions (:enable t :lint t)))
    ((dot/node-project-p)
      '("typescript-language-server" "--stdio"))
    (t
      nil)))

(use-package typescript-ts-mode :mode "\\.ts\\'")

(provide 'init-js)
