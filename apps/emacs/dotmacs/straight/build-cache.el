
:tanat

"28.2"

#s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data ("straight" ("2022-12-24 13:10:55" ("emacs") (:type git :host github :repo "radian-software/straight.el" :files ("straight*.el") :branch "master" :package "straight" :local-repo "straight.el")) "org-elpa" ("2022-12-24 13:10:55" nil (:local-repo nil :package "org-elpa" :type git)) "melpa" ("2022-12-24 13:10:55" nil (:type git :host github :repo "melpa/melpa" :build nil :package "melpa" :local-repo "melpa")) "gnu-elpa-mirror" ("2022-12-24 13:10:55" nil (:type git :host github :repo "emacs-straight/gnu-elpa-mirror" :build nil :package "gnu-elpa-mirror" :local-repo "gnu-elpa-mirror")) "nongnu-elpa" ("2022-12-24 13:10:55" nil (:type git :repo "https://git.savannah.gnu.org/git/emacs/nongnu.git" :local-repo "nongnu-elpa" :build nil :package "nongnu-elpa")) "el-get" ("2022-12-24 13:10:55" nil (:type git :host github :repo "dimitri/el-get" :build nil :files ("*.el" ("recipes" "recipes/el-get.rcp") "methods" "el-get-pkg.el") :flavor melpa :package "el-get" :local-repo "el-get")) "emacsmirror-mirror" ("2022-12-24 13:10:55" nil (:type git :host github :repo "emacs-straight/emacsmirror-mirror" :build nil :package "emacsmirror-mirror" :local-repo "emacsmirror-mirror")) "use-package" ("2022-12-24 13:10:55" ("emacs" "bind-key") (:type git :flavor melpa :files (:defaults (:exclude "bind-key.el" "bind-chord.el" "use-package-chords.el" "use-package-ensure-system-package.el") "use-package-pkg.el") :host github :repo "jwiegley/use-package" :package "use-package" :local-repo "use-package")) "bind-key" ("2022-12-24 13:10:55" ("emacs") (:flavor melpa :files ("bind-key.el" "bind-key-pkg.el") :package "bind-key" :local-repo "use-package" :type git :repo "jwiegley/use-package" :host github)) "evil" ("2022-12-24 13:10:55" ("emacs" "goto-chg" "cl-lib") (:type git :flavor melpa :files (:defaults "doc/build/texinfo/evil.texi" (:exclude "evil-test-helpers.el") "evil-pkg.el") :host github :repo "emacs-evil/evil" :package "evil" :local-repo "evil")) "goto-chg" ("2022-12-24 13:10:55" ("emacs") (:type git :flavor melpa :host github :repo "emacs-evil/goto-chg" :package "goto-chg" :local-repo "goto-chg")) "base16-theme" ("2022-12-24 13:10:39" nil (:type git :flavor melpa :files (:defaults "build/*.el" "base16-theme-pkg.el") :host github :repo "tinted-theming/base16-emacs" :package "base16-theme" :local-repo "base16-emacs"))))

#s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data ("straight" ((straight-autoloads straight straight-x straight-ert-print-hack) (autoload 'straight-remove-unused-repos "straight" "Remove unused repositories from the repos and build directories.
A repo is considered \"unused\" if it was not explicitly requested via
`straight-use-package' during the current Emacs session.
If FORCE is non-nil do not prompt before deleting repos.

(fn &optional FORCE)" t nil) (autoload 'straight-get-recipe "straight" "Interactively select a recipe from one of the recipe repositories.
All recipe repositories in `straight-recipe-repositories' will
first be cloned. After the recipe is selected, it will be copied
to the kill ring. With a prefix argument, first prompt for a
recipe repository to search. Only that repository will be
cloned.

From Lisp code, SOURCES should be a subset of the symbols in
`straight-recipe-repositories'. Only those recipe repositories
are cloned and searched. If it is nil or omitted, then the value
of `straight-recipe-repositories' is used. If SOURCES is the
symbol `interactive', then the user is prompted to select a
recipe repository, and a list containing that recipe repository
is used for the value of SOURCES. ACTION may be `copy' (copy
recipe to the kill ring), `insert' (insert at point), or nil (no
action, just return it).

(fn &optional SOURCES ACTION)" t nil) (autoload 'straight-visit-package-website "straight" "Visit the package RECIPE's website.

(fn RECIPE)" t nil) (autoload 'straight-visit-package "straight" "Open PACKAGE's local repository directory.
When BUILD is non-nil visit PACKAGE's build directory.

(fn PACKAGE &optional BUILD)" t nil) (autoload 'straight-use-package "straight" "Register, clone, build, and activate a package and its dependencies.
This is the main entry point to the functionality of straight.el.

MELPA-STYLE-RECIPE is either a symbol naming a package, or a list
whose car is a symbol naming a package and whose cdr is a
property list containing e.g. `:type', `:local-repo', `:files',
and VC backend specific keywords.

First, the package recipe is registered with straight.el. If
NO-CLONE is a function, then it is called with two arguments: the
package name as a string, and a boolean value indicating whether
the local repository for the package is available. In that case,
the return value of the function is used as the value of NO-CLONE
instead. In any case, if NO-CLONE is non-nil, then processing
stops here.

Otherwise, the repository is cloned, if it is missing. If
NO-BUILD is a function, then it is called with one argument: the
package name as a string. In that case, the return value of the
function is used as the value of NO-BUILD instead. In any case,
if NO-BUILD is non-nil, then processing halts here. Otherwise,
the package is built and activated. Note that if the package
recipe has a nil `:build' entry, then NO-BUILD is ignored
and processing always stops before building and activation
occurs.

CAUSE is a string explaining the reason why
`straight-use-package' has been called. It is for internal use
only, and is used to construct progress messages. INTERACTIVE is
non-nil if the function has been called interactively. It is for
internal use only, and is used to determine whether to show a
hint about how to install the package permanently.

Return non-nil if package was actually installed, and nil
otherwise (this can only happen if NO-CLONE is non-nil).

(fn MELPA-STYLE-RECIPE &optional NO-CLONE NO-BUILD CAUSE INTERACTIVE)" t nil) (autoload 'straight-register-package "straight" "Register a package without cloning, building, or activating it.
This function is equivalent to calling `straight-use-package'
with a non-nil argument for NO-CLONE. It is provided for
convenience. MELPA-STYLE-RECIPE is as for
`straight-use-package'.

(fn MELPA-STYLE-RECIPE)" nil nil) (autoload 'straight-use-package-no-build "straight" "Register and clone a package without building it.
This function is equivalent to calling `straight-use-package'
with nil for NO-CLONE but a non-nil argument for NO-BUILD. It is
provided for convenience. MELPA-STYLE-RECIPE is as for
`straight-use-package'.

(fn MELPA-STYLE-RECIPE)" nil nil) (autoload 'straight-use-package-lazy "straight" "Register, build, and activate a package if it is already cloned.
This function is equivalent to calling `straight-use-package'
with symbol `lazy' for NO-CLONE. It is provided for convenience.
MELPA-STYLE-RECIPE is as for `straight-use-package'.

(fn MELPA-STYLE-RECIPE)" nil nil) (autoload 'straight-use-recipes "straight" "Register a recipe repository using MELPA-STYLE-RECIPE.
This registers the recipe and builds it if it is already cloned.
Note that you probably want the recipe for a recipe repository to
include a nil `:build' property, to unconditionally
inhibit the build phase.

This function also adds the recipe repository to
`straight-recipe-repositories', at the end of the list.

(fn MELPA-STYLE-RECIPE)" nil nil) (autoload 'straight-override-recipe "straight" "Register MELPA-STYLE-RECIPE as a recipe override.
This puts it in `straight-recipe-overrides', depending on the
value of `straight-current-profile'.

(fn MELPA-STYLE-RECIPE)" nil nil) (autoload 'straight-check-package "straight" "Rebuild a PACKAGE if it has been modified.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. See also `straight-rebuild-package' and
`straight-check-all'.

(fn PACKAGE)" t nil) (autoload 'straight-check-all "straight" "Rebuild any packages that have been modified.
See also `straight-rebuild-all' and `straight-check-package'.
This function should not be called during init." t nil) (autoload 'straight-rebuild-package "straight" "Rebuild a PACKAGE.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument RECURSIVE, rebuild
all dependencies as well. See also `straight-check-package' and
`straight-rebuild-all'.

(fn PACKAGE &optional RECURSIVE)" t nil) (autoload 'straight-rebuild-all "straight" "Rebuild all packages.
See also `straight-check-all' and `straight-rebuild-package'." t nil) (autoload 'straight-prune-build-cache "straight" "Prune the build cache.
This means that only packages that were built in the last init
run and subsequent interactive session will remain; other
packages will have their build mtime information and any cached
autoloads discarded." nil nil) (autoload 'straight-prune-build-directory "straight" "Prune the build directory.
This means that only packages that were built in the last init
run and subsequent interactive session will remain; other
packages will have their build directories deleted." nil nil) (autoload 'straight-prune-build "straight" "Prune the build cache and build directory.
This means that only packages that were built in the last init
run and subsequent interactive session will remain; other
packages will have their build mtime information discarded and
their build directories deleted." t nil) (autoload 'straight-normalize-package "straight" "Normalize a PACKAGE's local repository to its recipe's configuration.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'.

(fn PACKAGE)" t nil) (autoload 'straight-normalize-all "straight" "Normalize all packages. See `straight-normalize-package'.
Return a list of recipes for packages that were not successfully
normalized. If multiple packages come from the same local
repository, only one is normalized.

PREDICATE, if provided, filters the packages that are normalized.
It is called with the package name as a string, and should return
non-nil if the package should actually be normalized.

(fn &optional PREDICATE)" t nil) (autoload 'straight-fetch-package "straight" "Try to fetch a PACKAGE from the primary remote.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM,
fetch not just from primary remote but also from upstream (for
forked packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-fetch-package-and-deps "straight" "Try to fetch a PACKAGE and its (transitive) dependencies.
PACKAGE, its dependencies, their dependencies, etc. are fetched
from their primary remotes.

PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM,
fetch not just from primary remote but also from upstream (for
forked packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-fetch-all "straight" "Try to fetch all packages from their primary remotes.
With prefix argument FROM-UPSTREAM, fetch not just from primary
remotes but also from upstreams (for forked packages).

Return a list of recipes for packages that were not successfully
fetched. If multiple packages come from the same local
repository, only one is fetched.

PREDICATE, if provided, filters the packages that are fetched. It
is called with the package name as a string, and should return
non-nil if the package should actually be fetched.

(fn &optional FROM-UPSTREAM PREDICATE)" t nil) (autoload 'straight-merge-package "straight" "Try to merge a PACKAGE from the primary remote.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM,
merge not just from primary remote but also from upstream (for
forked packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-merge-package-and-deps "straight" "Try to merge a PACKAGE and its (transitive) dependencies.
PACKAGE, its dependencies, their dependencies, etc. are merged
from their primary remotes.

PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM,
merge not just from primary remote but also from upstream (for
forked packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-merge-all "straight" "Try to merge all packages from their primary remotes.
With prefix argument FROM-UPSTREAM, merge not just from primary
remotes but also from upstreams (for forked packages).

Return a list of recipes for packages that were not successfully
merged. If multiple packages come from the same local
repository, only one is merged.

PREDICATE, if provided, filters the packages that are merged. It
is called with the package name as a string, and should return
non-nil if the package should actually be merged.

(fn &optional FROM-UPSTREAM PREDICATE)" t nil) (autoload 'straight-pull-package "straight" "Try to pull a PACKAGE from the primary remote.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM, pull
not just from primary remote but also from upstream (for forked
packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-pull-package-and-deps "straight" "Try to pull a PACKAGE and its (transitive) dependencies.
PACKAGE, its dependencies, their dependencies, etc. are pulled
from their primary remotes.

PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM,
pull not just from primary remote but also from upstream (for
forked packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-pull-all "straight" "Try to pull all packages from their primary remotes.
With prefix argument FROM-UPSTREAM, pull not just from primary
remotes but also from upstreams (for forked packages).

Return a list of recipes for packages that were not successfully
pulled. If multiple packages come from the same local repository,
only one is pulled.

PREDICATE, if provided, filters the packages that are pulled. It
is called with the package name as a string, and should return
non-nil if the package should actually be pulled.

(fn &optional FROM-UPSTREAM PREDICATE)" t nil) (autoload 'straight-push-package "straight" "Push a PACKAGE to its primary remote, if necessary.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'.

(fn PACKAGE)" t nil) (autoload 'straight-push-all "straight" "Try to push all packages to their primary remotes.

Return a list of recipes for packages that were not successfully
pushed. If multiple packages come from the same local repository,
only one is pushed.

PREDICATE, if provided, filters the packages that are normalized.
It is called with the package name as a string, and should return
non-nil if the package should actually be normalized.

(fn &optional PREDICATE)" t nil) (autoload 'straight-freeze-versions "straight" "Write version lockfiles for currently activated packages.
This implies first pushing all packages that have unpushed local
changes. If the package management system has been used since the
last time the init-file was reloaded, offer to fix the situation
by reloading the init-file again. If FORCE is
non-nil (interactively, if a prefix argument is provided), skip
all checks and write the lockfile anyway.

Currently, writing version lockfiles requires cloning all lazily
installed packages. Hopefully, this inconvenient requirement will
be removed in the future.

Multiple lockfiles may be written (one for each profile),
according to the value of `straight-profiles'.

(fn &optional FORCE)" t nil) (autoload 'straight-thaw-versions "straight" "Read version lockfiles and restore package versions to those listed." t nil) (autoload 'straight-bug-report "straight" "Test straight.el in a clean environment.
ARGS may be any of the following keywords and their respective values:
  - :pre-bootstrap (Form)...
      Forms evaluated before bootstrapping straight.el
      e.g. (setq straight-repository-branch \"develop\")
      Note this example is already in the default bootstrapping code.

  - :post-bootstrap (Form)...
      Forms evaluated in the testing environment after boostrapping.
      e.g. (straight-use-package \\='(example :type git :host github))

  - :interactive Boolean
      If nil, the subprocess will immediately exit after the test.
      Output will be printed to `straight-bug-report--process-buffer'
      Otherwise, the subprocess will be interactive.

  - :preserve Boolean
      If non-nil, the test directory is left in the directory stored in the
      variable `temporary-file-directory'. Otherwise, it is
      immediately removed after the test is run.

  - :executable String
      Indicate the Emacs executable to launch.
      Defaults to the path of the current Emacs executable.

  - :raw Boolean
      If non-nil, the raw process output is sent to
      `straight-bug-report--process-buffer'. Otherwise, it is
      formatted as markdown for submitting as an issue.

  - :user-dir String
      If non-nil, the test is run with `user-emacs-directory' set to STRING.
      Otherwise, a temporary directory is created and used.
      Unless absolute, paths are expanded relative to the variable
      `temporary-file-directory'.

ARGS are accessible within the :pre/:post-bootsrap phases via the
locally bound plist, straight-bug-report-args.

(fn &rest ARGS)" nil t) (function-put 'straight-bug-report 'lisp-indent-function '0) (autoload 'straight-dependencies "straight" "Return a list of PACKAGE's dependencies.

(fn &optional PACKAGE)" t nil) (autoload 'straight-dependents "straight" "Return a list PACKAGE's dependents.

(fn &optional PACKAGE)" t nil) (register-definition-prefixes "straight" '("straight-")) (register-definition-prefixes "straight-ert-print-hack" '("+without-print-limits")) (defvar straight-x-pinned-packages nil "List of pinned packages.") (register-definition-prefixes "straight-x" '("straight-x-")) (provide 'straight-autoloads)) "bind-key" ((bind-key bind-key-autoloads) (autoload 'bind-key "bind-key" "Bind KEY-NAME to COMMAND in KEYMAP (`global-map' if not passed).

KEY-NAME may be a vector, in which case it is passed straight to
`define-key'.  Or it may be a string to be interpreted as
spelled-out keystrokes, e.g., \"C-c C-z\".  See the documentation
of `edmacro-mode' for details.

COMMAND must be an interactive function or lambda form.

KEYMAP, if present, should be a keymap variable or symbol.
For example:

  (bind-key \"M-h\" #\\='some-interactive-function my-mode-map)

  (bind-key \"M-h\" #\\='some-interactive-function \\='my-mode-map)

If PREDICATE is non-nil, it is a form evaluated to determine when
a key should be bound. It must return non-nil in such cases.
Emacs can evaluate this form at any time that it does redisplay
or operates on menu data structures, so you should write it so it
can safely be called at any time.

(fn KEY-NAME COMMAND &optional KEYMAP PREDICATE)" nil t) (autoload 'unbind-key "bind-key" "Unbind the given KEY-NAME, within the KEYMAP (if specified).
See `bind-key' for more details.

(fn KEY-NAME &optional KEYMAP)" nil t) (autoload 'bind-key* "bind-key" "Similar to `bind-key', but overrides any mode-specific bindings.

(fn KEY-NAME COMMAND &optional PREDICATE)" nil t) (autoload 'bind-keys "bind-key" "Bind multiple keys at once.

Accepts keyword arguments:
:map MAP               - a keymap into which the keybindings should be
                         added
:prefix KEY            - prefix key for these bindings
:prefix-map MAP        - name of the prefix map that should be created
                         for these bindings
:prefix-docstring STR  - docstring for the prefix-map variable
:menu-name NAME        - optional menu string for prefix map
:repeat-docstring STR  - docstring for the repeat-map variable
:repeat-map MAP        - name of the repeat map that should be created
                         for these bindings. If specified, the
                         `repeat-map' property of each command bound
                         (within the scope of the `:repeat-map' keyword)
                         is set to this map.
:exit BINDINGS         - Within the scope of `:repeat-map' will bind the
                         key in the repeat map, but will not set the
                         `repeat-map' property of the bound command.
:continue BINDINGS     - Within the scope of `:repeat-map' forces the
                         same behaviour as if no special keyword had
                         been used (that is, the command is bound, and
                         it's `repeat-map' property set)
:filter FORM           - optional form to determine when bindings apply

The rest of the arguments are conses of keybinding string and a
function symbol (unquoted).

(fn &rest ARGS)" nil t) (autoload 'bind-keys* "bind-key" "Bind multiple keys at once, in `override-global-map'.
Accepts the same keyword arguments as `bind-keys' (which see).

This binds keys in such a way that bindings are not overridden by
other modes.  See `override-global-mode'.

(fn &rest ARGS)" nil t) (autoload 'describe-personal-keybindings "bind-key" "Display all the personal keybindings defined by `bind-key'." t nil) (register-definition-prefixes "bind-key" '("bind-key" "compare-keybindings" "get-binding-description" "override-global-m" "personal-keybindings")) (provide 'bind-key-autoloads)) "use-package" ((use-package-delight use-package-diminish use-package-jump use-package-ensure use-package-lint use-package-bind-key use-package-core use-package use-package-autoloads) (autoload 'use-package-autoload-keymap "use-package-bind-key" "Load PACKAGE and bind key sequence invoking this function to KEYMAP-SYMBOL.
Then simulate pressing the same key sequence a again, so that the
next key pressed is routed to the newly loaded keymap.

This function supports use-package's :bind-keymap keyword.  It
works by binding the given key sequence to an invocation of this
function for a particular keymap.  The keymap is expected to be
defined by the package.  In this way, loading the package is
deferred until the prefix key sequence is pressed.

(fn KEYMAP-SYMBOL PACKAGE OVERRIDE)" nil nil) (autoload 'use-package-normalize-binder "use-package-bind-key" "

(fn NAME KEYWORD ARGS)" nil nil) (defalias 'use-package-normalize/:bind 'use-package-normalize-binder) (defalias 'use-package-normalize/:bind* 'use-package-normalize-binder) (defalias 'use-package-autoloads/:bind 'use-package-autoloads-mode) (defalias 'use-package-autoloads/:bind* 'use-package-autoloads-mode) (autoload 'use-package-handler/:bind "use-package-bind-key" "

(fn NAME KEYWORD ARGS REST STATE &optional BIND-MACRO)" nil nil) (defalias 'use-package-normalize/:bind-keymap 'use-package-normalize-binder) (defalias 'use-package-normalize/:bind-keymap* 'use-package-normalize-binder) (autoload 'use-package-handler/:bind-keymap "use-package-bind-key" "

(fn NAME KEYWORD ARGS REST STATE &optional OVERRIDE)" nil nil) (autoload 'use-package-handler/:bind-keymap* "use-package-bind-key" "

(fn NAME KEYWORD ARG REST STATE)" nil nil) (register-definition-prefixes "use-package-bind-key" '("use-package-handler/:bind*")) (autoload 'use-package "use-package-core" "Declare an Emacs package by specifying a group of configuration options.

For the full documentation, see Info node `(use-package) top'.
Usage:

  (use-package package-name
     [:keyword [option]]...)

:init            Code to run before PACKAGE-NAME has been loaded.
:config          Code to run after PACKAGE-NAME has been loaded.  Note that
                 if loading is deferred for any reason, this code does not
                 execute until the lazy load has occurred.
:preface         Code to be run before everything except `:disabled'; this
                 can be used to define functions for use in `:if', or that
                 should be seen by the byte-compiler.

:mode            Form to be added to `auto-mode-alist'.
:magic           Form to be added to `magic-mode-alist'.
:magic-fallback  Form to be added to `magic-fallback-mode-alist'.
:interpreter     Form to be added to `interpreter-mode-alist'.

:commands        Define autoloads for commands that will be defined by the
                 package.  This is useful if the package is being lazily
                 loaded, and you wish to conditionally call functions in your
                 `:init' block that are defined in the package.
:autoload        Similar to :commands, but it for no-interactive one.
:hook            Specify hook(s) to attach this package to.

:bind            Bind keys, and define autoloads for the bound commands.
:bind*           Bind keys, and define autoloads for the bound commands,
                 *overriding all minor mode bindings*.
:bind-keymap     Bind a key prefix to an auto-loaded keymap defined in the
                 package.  This is like `:bind', but for keymaps.
:bind-keymap*    Like `:bind-keymap', but overrides all minor mode bindings

:defer           Defer loading of a package -- this is implied when using
                 `:commands', `:bind', `:bind*', `:mode', `:magic', `:hook',
                 `:magic-fallback', or `:interpreter'.  This can be an integer,
                 to force loading after N seconds of idle time, if the package
                 has not already been loaded.
:demand          Prevent the automatic deferred loading introduced by constructs
                 such as `:bind' (see `:defer' for the complete list).

:after           Delay the effect of the use-package declaration
                 until after the named libraries have loaded.
                 Before they have been loaded, no other keyword
                 has any effect at all, and once they have been
                 loaded it is as if `:after' was not specified.

:if EXPR         Initialize and load only if EXPR evaluates to a non-nil value.
:disabled        The package is ignored completely if this keyword is present.
:defines         Declare certain variables to silence the byte-compiler.
:functions       Declare certain functions to silence the byte-compiler.
:load-path       Add to the `load-path' before attempting to load the package.
:diminish        Support for diminish.el (if installed).
:delight         Support for delight.el (if installed).
:custom          Call `Custom-set' or `set-default' with each variable
                 definition without modifying the Emacs `custom-file'.
                 (compare with `custom-set-variables').
:custom-face     Call `custom-set-faces' with each face definition.
:ensure          Loads the package using package.el if necessary.
:pin             Pin the package to an archive.

(fn NAME &rest ARGS)" nil t) (function-put 'use-package 'lisp-indent-function 'defun) (register-definition-prefixes "use-package-core" '("use-package-")) (autoload 'use-package-normalize/:delight "use-package-delight" "Normalize arguments to delight.

(fn NAME KEYWORD ARGS)" nil nil) (autoload 'use-package-handler/:delight "use-package-delight" "

(fn NAME KEYWORD ARGS REST STATE)" nil nil) (register-definition-prefixes "use-package-delight" '("use-package-normalize-delight")) (autoload 'use-package-normalize/:diminish "use-package-diminish" "

(fn NAME KEYWORD ARGS)" nil nil) (autoload 'use-package-handler/:diminish "use-package-diminish" "

(fn NAME KEYWORD ARG REST STATE)" nil nil) (register-definition-prefixes "use-package-diminish" '("use-package-normalize-diminish")) (autoload 'use-package-normalize/:ensure "use-package-ensure" "

(fn NAME KEYWORD ARGS)" nil nil) (autoload 'use-package-handler/:ensure "use-package-ensure" "

(fn NAME KEYWORD ENSURE REST STATE)" nil nil) (register-definition-prefixes "use-package-ensure" '("use-package-")) (autoload 'use-package-jump-to-package-form "use-package-jump" "Attempt to find and jump to the `use-package' form that loaded PACKAGE.
This will only find the form if that form actually required
PACKAGE.  If PACKAGE was previously required then this function
will jump to the file that originally required PACKAGE instead.

(fn PACKAGE)" t nil) (register-definition-prefixes "use-package-jump" '("use-package-find-require")) (autoload 'use-package-lint "use-package-lint" "Check for errors in `use-package' declarations.
For example, if the module's `:if' condition is met, but even
with the specified `:load-path' the module cannot be found." t nil) (register-definition-prefixes "use-package-lint" '("use-package-lint-declaration")) (provide 'use-package-autoloads)) "goto-chg" ((goto-chg-autoloads goto-chg) (autoload 'goto-last-change "goto-chg" "Go to the point where the last edit was made in the current buffer.
Repeat the command to go to the second last edit, etc.

To go back to more recent edit, the reverse of this command, use \\[goto-last-change-reverse]
or precede this command with \\[universal-argument] - (minus).

It does not go to the same point twice even if there has been many edits
there. I call the minimal distance between distinguishable edits \"span\".
Set variable `glc-default-span' to control how close is \"the same point\".
Default span is 8.
The span can be changed temporarily with \\[universal-argument] right before \\[goto-last-change]:
\\[universal-argument] <NUMBER> set current span to that number,
\\[universal-argument] (no number) multiplies span by 4, starting with default.
The so set span remains until it is changed again with \\[universal-argument], or the consecutive
repetition of this command is ended by any other command.

When span is zero (i.e. \\[universal-argument] 0) subsequent \\[goto-last-change] visits each and
every point of edit and a message shows what change was made there.
In this case it may go to the same point twice.

This command uses undo information. If undo is disabled, so is this command.
At times, when undo information becomes too large, the oldest information is
discarded. See variable `undo-limit'.

(fn ARG)" t nil) (autoload 'goto-last-change-reverse "goto-chg" "Go back to more recent changes after \\[goto-last-change] have been used.
See `goto-last-change' for use of prefix argument.

(fn ARG)" t nil) (register-definition-prefixes "goto-chg" '("glc-")) (provide 'goto-chg-autoloads)) "evil" ((evil-integration evil-ex evil-search evil-pkg evil-repeat evil-development evil-command-window evil-core evil-maps evil-states evil-common evil-jumps evil-vars evil-digraphs evil evil-types evil-commands evil-macros evil-keybindings evil-autoloads) (register-definition-prefixes "evil-command-window" '("evil-")) (register-definition-prefixes "evil-commands" '("evil-")) (register-definition-prefixes "evil-common" '("bounds-of-evil-" "evil-" "forward-evil-")) (autoload 'evil-mode "evil" nil t) (register-definition-prefixes "evil-core" '("evil-" "turn-o")) (register-definition-prefixes "evil-digraphs" '("evil-digraph")) (register-definition-prefixes "evil-ex" '("evil-")) (register-definition-prefixes "evil-integration" '("evil-")) (register-definition-prefixes "evil-jumps" '("evil-")) (register-definition-prefixes "evil-macros" '("evil-")) (register-definition-prefixes "evil-maps" '("evil-")) (register-definition-prefixes "evil-repeat" '("evil-")) (register-definition-prefixes "evil-search" '("evil-")) (register-definition-prefixes "evil-states" '("evil-")) (register-definition-prefixes "evil-types" '("evil-ex-get-optional-register-and-count")) (register-definition-prefixes "evil-vars" '("evil-")) (provide 'evil-autoloads)) "base16-theme" ((base16-sakura-theme base16-black-metal-mayhem-theme base16-pandora-theme base16-grayscale-light-theme base16-pinky-theme base16-zenburn-theme base16-windows-highcontrast-theme base16-github-theme base16-google-light-theme base16-hopscotch-theme base16-atelier-forest-light-theme base16-solarized-light-theme base16-tomorrow-night-eighties-theme base16-atelier-forest-theme base16-black-metal-nile-theme base16-papercolor-light-theme base16-spaceduck-theme base16-kanagawa-theme base16-atelier-estuary-light-theme base16-synth-midnight-light-theme base16-gruvbox-dark-pale-theme base16-selenized-white-theme base16-tokyo-city-light-theme base16-bright-theme base16-atelier-savanna-theme base16-atelier-plateau-light-theme base16-theme-autoloads base16-embers-theme base16-gruvbox-material-light-hard-theme base16-emil-theme base16-atelier-sulphurpool-light-theme base16-rose-pine-dawn-theme base16-windows-10-theme base16-brewer-theme base16-unikitty-light-theme base16-monokai-theme base16-black-metal-venom-theme base16-gruvbox-material-light-soft-theme base16-ocean-theme base16-porple-theme base16-darkviolet-theme base16-da-one-white-theme base16-windows-nt-theme base16-black-metal-dark-funeral-theme base16-materia-theme base16-material-vivid-theme base16-marrakesh-theme base16-da-one-paper-theme base16-catppuccin-theme base16-shades-of-purple-theme base16-windows-10-light-theme base16-primer-dark-dimmed-theme base16-kimber-theme base16-google-dark-theme base16-black-metal-khold-theme base16-espresso-theme base16-black-metal-immortal-theme base16-classic-dark-theme base16-da-one-gray-theme base16-flat-theme base16-theme-pkg base16-dirtysea-theme base16-pop-theme base16-equilibrium-light-theme base16-helios-theme base16-gruvbox-dark-medium-theme base16-cupertino-theme base16-shadesmear-dark-theme base16-ayu-mirage-theme base16-tomorrow-theme base16-selenized-dark-theme base16-onedark-theme base16-atelier-seaside-theme base16-gruber-theme base16-tokyo-city-terminal-dark-theme base16-material-lighter-theme base16-nova-theme base16-material-palenight-theme base16-tomorrow-night-theme base16-equilibrium-gray-dark-theme base16-gruvbox-light-medium-theme base16-chalk-theme base16-darcula-theme base16-atelier-sulphurpool-theme base16-humanoid-dark-theme base16-mocha-theme base16-oceanicnext-theme base16-nebula-theme base16-gigavolt-theme base16-horizon-terminal-dark-theme base16-solarflare-theme base16-spacemacs-theme base16-equilibrium-dark-theme base16-black-metal-bathory-theme base16-darkmoss-theme base16-heetch-light-theme base16-atelier-cave-theme base16-unikitty-dark-theme base16-atelier-dune-theme base16-stella-theme base16-codeschool-theme base16-windows-highcontrast-light-theme base16-tube-theme base16-tokyo-city-terminal-light-theme base16-gruvbox-material-light-medium-theme base16-qualia-theme base16-sandcastle-theme base16-summercamp-theme base16-seti-theme base16-horizon-light-theme base16-windows-nt-light-theme base16-black-metal-gorgoroth-theme base16-grayscale-dark-theme base16-pico-theme base16-papercolor-dark-theme base16-material-darker-theme base16-black-metal-theme base16-gruvbox-light-hard-theme base16-eva-theme base16-ayu-dark-theme base16-snazzy-theme base16-gruvbox-light-soft-theme base16-classic-light-theme base16-heetch-theme base16-vice-theme base16-gruvbox-material-dark-soft-theme base16-da-one-ocean-theme base16-gruvbox-material-dark-hard-theme base16-apprentice-theme base16-danqing-theme base16-greenscreen-theme base16-blueforest-theme base16-circus-theme base16-pasque-theme base16-paraiso-theme base16-phd-theme base16-unikitty-reversible-theme base16-rebecca-theme base16-twilight-theme base16-uwunicorn-theme base16-windows-95-light-theme base16-fruit-soda-theme base16-hardcore-theme base16-gruvbox-material-dark-medium-theme base16-still-alive-theme base16-atelier-estuary-theme base16-synth-midnight-dark-theme base16-gotham-theme base16-cupcake-theme base16-primer-dark-theme base16-silk-light-theme base16-atelier-cave-light-theme base16-icy-theme base16-tokyo-night-storm-theme base16-black-metal-marduk-theme base16-da-one-sea-theme base16-mellow-purple-theme base16-default-light-theme base16-summerfruit-light-theme base16-harmonic16-dark-theme base16-atelier-plateau-theme base16-default-dark-theme base16-tokyodark-theme base16-lime-theme base16-purpledream-theme base16-brushtrees-theme base16-ashes-theme base16-mexico-light-theme base16-railscasts-theme base16-irblack-theme base16-dracula-theme base16-brogrammer-theme base16-outrun-dark-theme base16-tokyo-night-light-theme base16-one-light-theme base16-ia-dark-theme base16-colors-theme base16-black-metal-burzum-theme base16-tokyo-night-terminal-dark-theme base16-silk-dark-theme base16-zenbones-theme base16-theme base16-material-theme base16-atlas-theme base16-bespin-theme base16-danqing-light-theme base16-horizon-dark-theme base16-tokyo-night-dark-theme base16-atelier-lakeside-theme base16-framer-theme base16-edge-dark-theme base16-edge-light-theme base16-tokyodark-terminal-theme base16-isotope-theme base16-apathy-theme base16-tokyo-night-terminal-storm-theme base16-ia-light-theme base16-katy-theme base16-solarized-dark-theme base16-tender-theme base16-humanoid-light-theme base16-xcode-dusk-theme base16-sagelight-theme base16-rose-pine-moon-theme base16-tango-theme base16-decaf-theme base16-woodland-theme base16-brushtrees-dark-theme base16-3024-theme base16-solarflare-light-theme base16-da-one-black-theme base16-windows-95-theme base16-gruvbox-dark-hard-theme base16-gruvbox-dark-soft-theme base16-primer-light-theme base16-atelier-dune-light-theme base16-shadesmear-light-theme base16-tokyo-city-dark-theme base16-nord-theme base16-atelier-savanna-light-theme base16-vulcan-theme base16-atelier-heath-theme base16-atelier-seaside-light-theme base16-selenized-black-theme base16-harmonic16-light-theme base16-blueish-theme base16-everforest-theme base16-ayu-light-theme base16-macintosh-theme base16-atelier-heath-light-theme base16-atelier-lakeside-light-theme base16-horizon-terminal-light-theme base16-selenized-light-theme base16-darktooth-theme base16-rose-pine-theme base16-eva-dim-theme base16-shapeshifter-theme base16-summerfruit-dark-theme base16-tokyo-night-terminal-light-theme base16-eighties-theme base16-equilibrium-gray-light-theme) (register-definition-prefixes "base16-3024-theme" '("base16-3024-theme-colors")) (register-definition-prefixes "base16-apathy-theme" '("base16-apathy-theme-colors")) (register-definition-prefixes "base16-apprentice-theme" '("base16-apprentice-theme-colors")) (register-definition-prefixes "base16-ashes-theme" '("base16-ashes-theme-colors")) (register-definition-prefixes "base16-atelier-cave-light-theme" '("base16-atelier-cave-light-theme-colors")) (register-definition-prefixes "base16-atelier-cave-theme" '("base16-atelier-cave-theme-colors")) (register-definition-prefixes "base16-atelier-dune-light-theme" '("base16-atelier-dune-light-theme-colors")) (register-definition-prefixes "base16-atelier-dune-theme" '("base16-atelier-dune-theme-colors")) (register-definition-prefixes "base16-atelier-estuary-light-theme" '("base16-atelier-estuary-light-theme-colors")) (register-definition-prefixes "base16-atelier-estuary-theme" '("base16-atelier-estuary-theme-colors")) (register-definition-prefixes "base16-atelier-forest-light-theme" '("base16-atelier-forest-light-theme-colors")) (register-definition-prefixes "base16-atelier-forest-theme" '("base16-atelier-forest-theme-colors")) (register-definition-prefixes "base16-atelier-heath-light-theme" '("base16-atelier-heath-light-theme-colors")) (register-definition-prefixes "base16-atelier-heath-theme" '("base16-atelier-heath-theme-colors")) (register-definition-prefixes "base16-atelier-lakeside-light-theme" '("base16-atelier-lakeside-light-theme-colors")) (register-definition-prefixes "base16-atelier-lakeside-theme" '("base16-atelier-lakeside-theme-colors")) (register-definition-prefixes "base16-atelier-plateau-light-theme" '("base16-atelier-plateau-light-theme-colors")) (register-definition-prefixes "base16-atelier-plateau-theme" '("base16-atelier-plateau-theme-colors")) (register-definition-prefixes "base16-atelier-savanna-light-theme" '("base16-atelier-savanna-light-theme-colors")) (register-definition-prefixes "base16-atelier-savanna-theme" '("base16-atelier-savanna-theme-colors")) (register-definition-prefixes "base16-atelier-seaside-light-theme" '("base16-atelier-seaside-light-theme-colors")) (register-definition-prefixes "base16-atelier-seaside-theme" '("base16-atelier-seaside-theme-colors")) (register-definition-prefixes "base16-atelier-sulphurpool-light-theme" '("base16-atelier-sulphurpool-light-theme-colors")) (register-definition-prefixes "base16-atelier-sulphurpool-theme" '("base16-atelier-sulphurpool-theme-colors")) (register-definition-prefixes "base16-atlas-theme" '("base16-atlas-theme-colors")) (register-definition-prefixes "base16-ayu-dark-theme" '("base16-ayu-dark-theme-colors")) (register-definition-prefixes "base16-ayu-light-theme" '("base16-ayu-light-theme-colors")) (register-definition-prefixes "base16-ayu-mirage-theme" '("base16-ayu-mirage-theme-colors")) (register-definition-prefixes "base16-bespin-theme" '("base16-bespin-theme-colors")) (register-definition-prefixes "base16-black-metal-bathory-theme" '("base16-black-metal-bathory-theme-colors")) (register-definition-prefixes "base16-black-metal-burzum-theme" '("base16-black-metal-burzum-theme-colors")) (register-definition-prefixes "base16-black-metal-dark-funeral-theme" '("base16-black-metal-dark-funeral-theme-colors")) (register-definition-prefixes "base16-black-metal-gorgoroth-theme" '("base16-black-metal-gorgoroth-theme-colors")) (register-definition-prefixes "base16-black-metal-immortal-theme" '("base16-black-metal-immortal-theme-colors")) (register-definition-prefixes "base16-black-metal-khold-theme" '("base16-black-metal-khold-theme-colors")) (register-definition-prefixes "base16-black-metal-marduk-theme" '("base16-black-metal-marduk-theme-colors")) (register-definition-prefixes "base16-black-metal-mayhem-theme" '("base16-black-metal-mayhem-theme-colors")) (register-definition-prefixes "base16-black-metal-nile-theme" '("base16-black-metal-nile-theme-colors")) (register-definition-prefixes "base16-black-metal-theme" '("base16-black-metal-theme-colors")) (register-definition-prefixes "base16-black-metal-venom-theme" '("base16-black-metal-venom-theme-colors")) (register-definition-prefixes "base16-blueforest-theme" '("base16-blueforest-theme-colors")) (register-definition-prefixes "base16-blueish-theme" '("base16-blueish-theme-colors")) (register-definition-prefixes "base16-brewer-theme" '("base16-brewer-theme-colors")) (register-definition-prefixes "base16-bright-theme" '("base16-bright-theme-colors")) (register-definition-prefixes "base16-brogrammer-theme" '("base16-brogrammer-theme-colors")) (register-definition-prefixes "base16-brushtrees-dark-theme" '("base16-brushtrees-dark-theme-colors")) (register-definition-prefixes "base16-brushtrees-theme" '("base16-brushtrees-theme-colors")) (register-definition-prefixes "base16-catppuccin-theme" '("base16-catppuccin-theme-colors")) (register-definition-prefixes "base16-chalk-theme" '("base16-chalk-theme-colors")) (register-definition-prefixes "base16-circus-theme" '("base16-circus-theme-colors")) (register-definition-prefixes "base16-classic-dark-theme" '("base16-classic-dark-theme-colors")) (register-definition-prefixes "base16-classic-light-theme" '("base16-classic-light-theme-colors")) (register-definition-prefixes "base16-codeschool-theme" '("base16-codeschool-theme-colors")) (register-definition-prefixes "base16-colors-theme" '("base16-colors-theme-colors")) (register-definition-prefixes "base16-cupcake-theme" '("base16-cupcake-theme-colors")) (register-definition-prefixes "base16-cupertino-theme" '("base16-cupertino-theme-colors")) (register-definition-prefixes "base16-da-one-black-theme" '("base16-da-one-black-theme-colors")) (register-definition-prefixes "base16-da-one-gray-theme" '("base16-da-one-gray-theme-colors")) (register-definition-prefixes "base16-da-one-ocean-theme" '("base16-da-one-ocean-theme-colors")) (register-definition-prefixes "base16-da-one-paper-theme" '("base16-da-one-paper-theme-colors")) (register-definition-prefixes "base16-da-one-sea-theme" '("base16-da-one-sea-theme-colors")) (register-definition-prefixes "base16-da-one-white-theme" '("base16-da-one-white-theme-colors")) (register-definition-prefixes "base16-danqing-light-theme" '("base16-danqing-light-theme-colors")) (register-definition-prefixes "base16-danqing-theme" '("base16-danqing-theme-colors")) (register-definition-prefixes "base16-darcula-theme" '("base16-darcula-theme-colors")) (register-definition-prefixes "base16-darkmoss-theme" '("base16-darkmoss-theme-colors")) (register-definition-prefixes "base16-darktooth-theme" '("base16-darktooth-theme-colors")) (register-definition-prefixes "base16-darkviolet-theme" '("base16-darkviolet-theme-colors")) (register-definition-prefixes "base16-decaf-theme" '("base16-decaf-theme-colors")) (register-definition-prefixes "base16-default-dark-theme" '("base16-default-dark-theme-colors")) (register-definition-prefixes "base16-default-light-theme" '("base16-default-light-theme-colors")) (register-definition-prefixes "base16-dirtysea-theme" '("base16-dirtysea-theme-colors")) (register-definition-prefixes "base16-dracula-theme" '("base16-dracula-theme-colors")) (register-definition-prefixes "base16-edge-dark-theme" '("base16-edge-dark-theme-colors")) (register-definition-prefixes "base16-edge-light-theme" '("base16-edge-light-theme-colors")) (register-definition-prefixes "base16-eighties-theme" '("base16-eighties-theme-colors")) (register-definition-prefixes "base16-embers-theme" '("base16-embers-theme-colors")) (register-definition-prefixes "base16-emil-theme" '("base16-emil-theme-colors")) (register-definition-prefixes "base16-equilibrium-dark-theme" '("base16-equilibrium-dark-theme-colors")) (register-definition-prefixes "base16-equilibrium-gray-dark-theme" '("base16-equilibrium-gray-dark-theme-colors")) (register-definition-prefixes "base16-equilibrium-gray-light-theme" '("base16-equilibrium-gray-light-theme-colors")) (register-definition-prefixes "base16-equilibrium-light-theme" '("base16-equilibrium-light-theme-colors")) (register-definition-prefixes "base16-espresso-theme" '("base16-espresso-theme-colors")) (register-definition-prefixes "base16-eva-dim-theme" '("base16-eva-dim-theme-colors")) (register-definition-prefixes "base16-eva-theme" '("base16-eva-theme-colors")) (register-definition-prefixes "base16-everforest-theme" '("base16-everforest-theme-colors")) (register-definition-prefixes "base16-flat-theme" '("base16-flat-theme-colors")) (register-definition-prefixes "base16-framer-theme" '("base16-framer-theme-colors")) (register-definition-prefixes "base16-fruit-soda-theme" '("base16-fruit-soda-theme-colors")) (register-definition-prefixes "base16-gigavolt-theme" '("base16-gigavolt-theme-colors")) (register-definition-prefixes "base16-github-theme" '("base16-github-theme-colors")) (register-definition-prefixes "base16-google-dark-theme" '("base16-google-dark-theme-colors")) (register-definition-prefixes "base16-google-light-theme" '("base16-google-light-theme-colors")) (register-definition-prefixes "base16-gotham-theme" '("base16-gotham-theme-colors")) (register-definition-prefixes "base16-grayscale-dark-theme" '("base16-grayscale-dark-theme-colors")) (register-definition-prefixes "base16-grayscale-light-theme" '("base16-grayscale-light-theme-colors")) (register-definition-prefixes "base16-greenscreen-theme" '("base16-greenscreen-theme-colors")) (register-definition-prefixes "base16-gruber-theme" '("base16-gruber-theme-colors")) (register-definition-prefixes "base16-gruvbox-dark-hard-theme" '("base16-gruvbox-dark-hard-theme-colors")) (register-definition-prefixes "base16-gruvbox-dark-medium-theme" '("base16-gruvbox-dark-medium-theme-colors")) (register-definition-prefixes "base16-gruvbox-dark-pale-theme" '("base16-gruvbox-dark-pale-theme-colors")) (register-definition-prefixes "base16-gruvbox-dark-soft-theme" '("base16-gruvbox-dark-soft-theme-colors")) (register-definition-prefixes "base16-gruvbox-light-hard-theme" '("base16-gruvbox-light-hard-theme-colors")) (register-definition-prefixes "base16-gruvbox-light-medium-theme" '("base16-gruvbox-light-medium-theme-colors")) (register-definition-prefixes "base16-gruvbox-light-soft-theme" '("base16-gruvbox-light-soft-theme-colors")) (register-definition-prefixes "base16-gruvbox-material-dark-hard-theme" '("base16-gruvbox-material-dark-hard-theme-colors")) (register-definition-prefixes "base16-gruvbox-material-dark-medium-theme" '("base16-gruvbox-material-dark-medium-theme-colors")) (register-definition-prefixes "base16-gruvbox-material-dark-soft-theme" '("base16-gruvbox-material-dark-soft-theme-colors")) (register-definition-prefixes "base16-gruvbox-material-light-hard-theme" '("base16-gruvbox-material-light-hard-theme-colors")) (register-definition-prefixes "base16-gruvbox-material-light-medium-theme" '("base16-gruvbox-material-light-medium-theme-colors")) (register-definition-prefixes "base16-gruvbox-material-light-soft-theme" '("base16-gruvbox-material-light-soft-theme-colors")) (register-definition-prefixes "base16-hardcore-theme" '("base16-hardcore-theme-colors")) (register-definition-prefixes "base16-harmonic16-dark-theme" '("base16-harmonic16-dark-theme-colors")) (register-definition-prefixes "base16-harmonic16-light-theme" '("base16-harmonic16-light-theme-colors")) (register-definition-prefixes "base16-heetch-light-theme" '("base16-heetch-light-theme-colors")) (register-definition-prefixes "base16-heetch-theme" '("base16-heetch-theme-colors")) (register-definition-prefixes "base16-helios-theme" '("base16-helios-theme-colors")) (register-definition-prefixes "base16-hopscotch-theme" '("base16-hopscotch-theme-colors")) (register-definition-prefixes "base16-horizon-dark-theme" '("base16-horizon-dark-theme-colors")) (register-definition-prefixes "base16-horizon-light-theme" '("base16-horizon-light-theme-colors")) (register-definition-prefixes "base16-horizon-terminal-dark-theme" '("base16-horizon-terminal-dark-theme-colors")) (register-definition-prefixes "base16-horizon-terminal-light-theme" '("base16-horizon-terminal-light-theme-colors")) (register-definition-prefixes "base16-humanoid-dark-theme" '("base16-humanoid-dark-theme-colors")) (register-definition-prefixes "base16-humanoid-light-theme" '("base16-humanoid-light-theme-colors")) (register-definition-prefixes "base16-ia-dark-theme" '("base16-ia-dark-theme-colors")) (register-definition-prefixes "base16-ia-light-theme" '("base16-ia-light-theme-colors")) (register-definition-prefixes "base16-icy-theme" '("base16-icy-theme-colors")) (register-definition-prefixes "base16-irblack-theme" '("base16-irblack-theme-colors")) (register-definition-prefixes "base16-isotope-theme" '("base16-isotope-theme-colors")) (register-definition-prefixes "base16-kanagawa-theme" '("base16-kanagawa-theme-colors")) (register-definition-prefixes "base16-katy-theme" '("base16-katy-theme-colors")) (register-definition-prefixes "base16-kimber-theme" '("base16-kimber-theme-colors")) (register-definition-prefixes "base16-lime-theme" '("base16-lime-theme-colors")) (register-definition-prefixes "base16-macintosh-theme" '("base16-macintosh-theme-colors")) (register-definition-prefixes "base16-marrakesh-theme" '("base16-marrakesh-theme-colors")) (register-definition-prefixes "base16-materia-theme" '("base16-materia-theme-colors")) (register-definition-prefixes "base16-material-darker-theme" '("base16-material-darker-theme-colors")) (register-definition-prefixes "base16-material-lighter-theme" '("base16-material-lighter-theme-colors")) (register-definition-prefixes "base16-material-palenight-theme" '("base16-material-palenight-theme-colors")) (register-definition-prefixes "base16-material-theme" '("base16-material-theme-colors")) (register-definition-prefixes "base16-material-vivid-theme" '("base16-material-vivid-theme-colors")) (register-definition-prefixes "base16-mellow-purple-theme" '("base16-mellow-purple-theme-colors")) (register-definition-prefixes "base16-mexico-light-theme" '("base16-mexico-light-theme-colors")) (register-definition-prefixes "base16-mocha-theme" '("base16-mocha-theme-colors")) (register-definition-prefixes "base16-monokai-theme" '("base16-monokai-theme-colors")) (register-definition-prefixes "base16-nebula-theme" '("base16-nebula-theme-colors")) (register-definition-prefixes "base16-nord-theme" '("base16-nord-theme-colors")) (register-definition-prefixes "base16-nova-theme" '("base16-nova-theme-colors")) (register-definition-prefixes "base16-ocean-theme" '("base16-ocean-theme-colors")) (register-definition-prefixes "base16-oceanicnext-theme" '("base16-oceanicnext-theme-colors")) (register-definition-prefixes "base16-one-light-theme" '("base16-one-light-theme-colors")) (register-definition-prefixes "base16-onedark-theme" '("base16-onedark-theme-colors")) (register-definition-prefixes "base16-outrun-dark-theme" '("base16-outrun-dark-theme-colors")) (register-definition-prefixes "base16-pandora-theme" '("base16-pandora-theme-colors")) (register-definition-prefixes "base16-papercolor-dark-theme" '("base16-papercolor-dark-theme-colors")) (register-definition-prefixes "base16-papercolor-light-theme" '("base16-papercolor-light-theme-colors")) (register-definition-prefixes "base16-paraiso-theme" '("base16-paraiso-theme-colors")) (register-definition-prefixes "base16-pasque-theme" '("base16-pasque-theme-colors")) (register-definition-prefixes "base16-phd-theme" '("base16-phd-theme-colors")) (register-definition-prefixes "base16-pico-theme" '("base16-pico-theme-colors")) (register-definition-prefixes "base16-pinky-theme" '("base16-pinky-theme-colors")) (register-definition-prefixes "base16-pop-theme" '("base16-pop-theme-colors")) (register-definition-prefixes "base16-porple-theme" '("base16-porple-theme-colors")) (register-definition-prefixes "base16-primer-dark-dimmed-theme" '("base16-primer-dark-dimmed-theme-colors")) (register-definition-prefixes "base16-primer-dark-theme" '("base16-primer-dark-theme-colors")) (register-definition-prefixes "base16-primer-light-theme" '("base16-primer-light-theme-colors")) (register-definition-prefixes "base16-purpledream-theme" '("base16-purpledream-theme-colors")) (register-definition-prefixes "base16-qualia-theme" '("base16-qualia-theme-colors")) (register-definition-prefixes "base16-railscasts-theme" '("base16-railscasts-theme-colors")) (register-definition-prefixes "base16-rebecca-theme" '("base16-rebecca-theme-colors")) (register-definition-prefixes "base16-rose-pine-dawn-theme" '("base16-rose-pine-dawn-theme-colors")) (register-definition-prefixes "base16-rose-pine-moon-theme" '("base16-rose-pine-moon-theme-colors")) (register-definition-prefixes "base16-rose-pine-theme" '("base16-rose-pine-theme-colors")) (register-definition-prefixes "base16-sagelight-theme" '("base16-sagelight-theme-colors")) (register-definition-prefixes "base16-sakura-theme" '("base16-sakura-theme-colors")) (register-definition-prefixes "base16-sandcastle-theme" '("base16-sandcastle-theme-colors")) (register-definition-prefixes "base16-selenized-black-theme" '("base16-selenized-black-theme-colors")) (register-definition-prefixes "base16-selenized-dark-theme" '("base16-selenized-dark-theme-colors")) (register-definition-prefixes "base16-selenized-light-theme" '("base16-selenized-light-theme-colors")) (register-definition-prefixes "base16-selenized-white-theme" '("base16-selenized-white-theme-colors")) (register-definition-prefixes "base16-seti-theme" '("base16-seti-theme-colors")) (register-definition-prefixes "base16-shades-of-purple-theme" '("base16-shades-of-purple-theme-colors")) (register-definition-prefixes "base16-shadesmear-dark-theme" '("base16-shadesmear-dark-theme-colors")) (register-definition-prefixes "base16-shadesmear-light-theme" '("base16-shadesmear-light-theme-colors")) (register-definition-prefixes "base16-shapeshifter-theme" '("base16-shapeshifter-theme-colors")) (register-definition-prefixes "base16-silk-dark-theme" '("base16-silk-dark-theme-colors")) (register-definition-prefixes "base16-silk-light-theme" '("base16-silk-light-theme-colors")) (register-definition-prefixes "base16-snazzy-theme" '("base16-snazzy-theme-colors")) (register-definition-prefixes "base16-solarflare-light-theme" '("base16-solarflare-light-theme-colors")) (register-definition-prefixes "base16-solarflare-theme" '("base16-solarflare-theme-colors")) (register-definition-prefixes "base16-solarized-dark-theme" '("base16-solarized-dark-theme-colors")) (register-definition-prefixes "base16-solarized-light-theme" '("base16-solarized-light-theme-colors")) (register-definition-prefixes "base16-spaceduck-theme" '("base16-spaceduck-theme-colors")) (register-definition-prefixes "base16-spacemacs-theme" '("base16-spacemacs-theme-colors")) (register-definition-prefixes "base16-stella-theme" '("base16-stella-theme-colors")) (register-definition-prefixes "base16-still-alive-theme" '("base16-still-alive-theme-colors")) (register-definition-prefixes "base16-summercamp-theme" '("base16-summercamp-theme-colors")) (register-definition-prefixes "base16-summerfruit-dark-theme" '("base16-summerfruit-dark-theme-colors")) (register-definition-prefixes "base16-summerfruit-light-theme" '("base16-summerfruit-light-theme-colors")) (register-definition-prefixes "base16-synth-midnight-dark-theme" '("base16-synth-midnight-dark-theme-colors")) (register-definition-prefixes "base16-synth-midnight-light-theme" '("base16-synth-midnight-light-theme-colors")) (register-definition-prefixes "base16-tango-theme" '("base16-tango-theme-colors")) (register-definition-prefixes "base16-tender-theme" '("base16-tender-theme-colors")) (and load-file-name (boundp 'custom-theme-load-path) (add-to-list 'custom-theme-load-path (file-name-as-directory (file-name-directory load-file-name)))) (register-definition-prefixes "base16-theme" '("base16-theme-")) (register-definition-prefixes "base16-tokyo-city-dark-theme" '("base16-tokyo-city-dark-theme-colors")) (register-definition-prefixes "base16-tokyo-city-light-theme" '("base16-tokyo-city-light-theme-colors")) (register-definition-prefixes "base16-tokyo-city-terminal-dark-theme" '("base16-tokyo-city-terminal-dark-theme-colors")) (register-definition-prefixes "base16-tokyo-city-terminal-light-theme" '("base16-tokyo-city-terminal-light-theme-colors")) (register-definition-prefixes "base16-tokyo-night-dark-theme" '("base16-tokyo-night-dark-theme-colors")) (register-definition-prefixes "base16-tokyo-night-light-theme" '("base16-tokyo-night-light-theme-colors")) (register-definition-prefixes "base16-tokyo-night-storm-theme" '("base16-tokyo-night-storm-theme-colors")) (register-definition-prefixes "base16-tokyo-night-terminal-dark-theme" '("base16-tokyo-night-terminal-dark-theme-colors")) (register-definition-prefixes "base16-tokyo-night-terminal-light-theme" '("base16-tokyo-night-terminal-light-theme-colors")) (register-definition-prefixes "base16-tokyo-night-terminal-storm-theme" '("base16-tokyo-night-terminal-storm-theme-colors")) (register-definition-prefixes "base16-tokyodark-terminal-theme" '("base16-tokyodark-terminal-theme-colors")) (register-definition-prefixes "base16-tokyodark-theme" '("base16-tokyodark-theme-colors")) (register-definition-prefixes "base16-tomorrow-night-eighties-theme" '("base16-tomorrow-night-eighties-theme-colors")) (register-definition-prefixes "base16-tomorrow-night-theme" '("base16-tomorrow-night-theme-colors")) (register-definition-prefixes "base16-tomorrow-theme" '("base16-tomorrow-theme-colors")) (register-definition-prefixes "base16-tube-theme" '("base16-tube-theme-colors")) (register-definition-prefixes "base16-twilight-theme" '("base16-twilight-theme-colors")) (register-definition-prefixes "base16-unikitty-dark-theme" '("base16-unikitty-dark-theme-colors")) (register-definition-prefixes "base16-unikitty-light-theme" '("base16-unikitty-light-theme-colors")) (register-definition-prefixes "base16-unikitty-reversible-theme" '("base16-unikitty-reversible-theme-colors")) (register-definition-prefixes "base16-uwunicorn-theme" '("base16-uwunicorn-theme-colors")) (register-definition-prefixes "base16-vice-theme" '("base16-vice-theme-colors")) (register-definition-prefixes "base16-vulcan-theme" '("base16-vulcan-theme-colors")) (register-definition-prefixes "base16-windows-10-light-theme" '("base16-windows-10-light-theme-colors")) (register-definition-prefixes "base16-windows-10-theme" '("base16-windows-10-theme-colors")) (register-definition-prefixes "base16-windows-95-light-theme" '("base16-windows-95-light-theme-colors")) (register-definition-prefixes "base16-windows-95-theme" '("base16-windows-95-theme-colors")) (register-definition-prefixes "base16-windows-highcontrast-light-theme" '("base16-windows-highcontrast-light-theme-colors")) (register-definition-prefixes "base16-windows-highcontrast-theme" '("base16-windows-highcontrast-theme-colors")) (register-definition-prefixes "base16-windows-nt-light-theme" '("base16-windows-nt-light-theme-colors")) (register-definition-prefixes "base16-windows-nt-theme" '("base16-windows-nt-theme-colors")) (register-definition-prefixes "base16-woodland-theme" '("base16-woodland-theme-colors")) (register-definition-prefixes "base16-xcode-dusk-theme" '("base16-xcode-dusk-theme-colors")) (register-definition-prefixes "base16-zenbones-theme" '("base16-zenbones-theme-colors")) (register-definition-prefixes "base16-zenburn-theme" '("base16-zenburn-theme-colors")) (provide 'base16-theme-autoloads))))

#s(hash-table size 65 test eq rehash-size 1.5 rehash-threshold 0.8125 data (org-elpa #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 14 "melpa" nil "gnu-elpa-mirror" nil "nongnu-elpa" nil "el-get" nil "emacsmirror-mirror" nil "straight" nil "use-package" nil "bind-key" nil "evil" nil "goto-chg" nil "cl-lib" nil "base16-theme" nil)) melpa #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 2 "gnu-elpa-mirror" nil "nongnu-elpa" nil "el-get" (el-get :type git :flavor melpa :files ("*.el" ("recipes" "recipes/el-get.rcp") "methods" "el-get-pkg.el") :host github :repo "dimitri/el-get") "emacsmirror-mirror" nil "straight" nil "use-package" (use-package :type git :flavor melpa :files (:defaults (:exclude "bind-key.el" "bind-chord.el" "use-package-chords.el" "use-package-ensure-system-package.el") "use-package-pkg.el") :host github :repo "jwiegley/use-package") "bind-key" (bind-key :type git :flavor melpa :files ("bind-key.el" "bind-key-pkg.el") :host github :repo "jwiegley/use-package") "evil" (evil :type git :flavor melpa :files (:defaults "doc/build/texinfo/evil.texi" (:exclude "evil-test-helpers.el") "evil-pkg.el") :host github :repo "emacs-evil/evil") "goto-chg" (goto-chg :type git :flavor melpa :host github :repo "emacs-evil/goto-chg") "cl-lib" nil "base16-theme" (base16-theme :type git :flavor melpa :files (:defaults "build/*.el" "base16-theme-pkg.el") :host github :repo "tinted-theming/base16-emacs"))) gnu-elpa-mirror #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 3 "nongnu-elpa" nil "emacsmirror-mirror" nil "straight" nil "cl-lib" nil)) nongnu-elpa #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 3 "emacsmirror-mirror" nil "straight" nil "cl-lib" nil)) el-get #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 2 "emacsmirror-mirror" nil "straight" nil "cl-lib" nil)) emacsmirror-mirror #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 2 "straight" (straight :type git :host github :repo "emacsmirror/straight") "cl-lib" nil))))

("org-elpa" "melpa" "gnu-elpa-mirror" "nongnu-elpa" "el-get" "emacsmirror-mirror" "straight" "emacs" "use-package" "bind-key" "evil" "goto-chg" "cl-lib")

t
