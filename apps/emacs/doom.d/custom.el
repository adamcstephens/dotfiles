(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-capture-templates
    '(("t" "Personal todo" entry
        (file+headline +org-capture-todo-file "Inbox")
        "* TODO %?
%i
%a" :prepend t)
       ("n" "Personal notes" entry
         (file+headline +org-capture-notes-file "Inbox")
         "* %u %?
%i
%a" :prepend t)
       ("j" "Journal" entry
         (file+olp+datetree +org-capture-journal-file)
         "* %U %?
%i
%a" :prepend t)
       ("p" "Templates for projects")
       ("pt" "Project-local todo" entry
         (file+headline +org-capture-project-todo-file "Inbox")
         "* TODO %?
%i
%a" :prepend t)
       ("pn" "Project-local notes" entry
         (file+headline +org-capture-project-notes-file "Inbox")
         "* %U %?
%i
%a" :prepend t)
       ("pc" "Project-local changelog" entry
         (file+headline +org-capture-project-changelog-file "Unreleased")
         "* %U %?
%i
%a" :prepend t)
       ("o" "Centralized templates for projects")
       ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?
 %i
 %a" :heading "Tasks" :prepend nil)
       ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?
 %i
 %a" :prepend t :heading "Notes")
       ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?
 %i
 %a" :prepend t :heading "Changelog")))
 '(org-re-reveal-klipse-extra-css
    "<style>
/* Position computations of klipse get confused by reveal.js's scaling.
   Hence, scaling should be disabled with this code.  Fix height of code area
   with scrollbar (use overflow instead of overflow-y to restore CodeMirror
   setting afterwards): */
.reveal section pre { max-height: 70vh; height: auto; overflow: auto; }
/* Reset some reveal.js and oer-reveal settings: */
.reveal section pre .CodeMirror pre { font-size: 2em; box-shadow: none; width: auto; padding: 0.4em; display: block; overflow: visible; }
/* Enlarge cursor: */
.CodeMirror-cursor { border-left: 3px solid #4fb4d8; }
</style>
")
 '(org-structure-template-alist
    '(("n" . "notes")
       ("a" . "export ascii")
       ("c" . "center")
       ("C" . "comment")
       ("e" . "example")
       ("E" . "export")
       ("h" . "export html")
       ("l" . "export latex")
       ("j" . "src js")
       ("q" . "quote")
       ("s" . "src")
       ("v" . "verse"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
