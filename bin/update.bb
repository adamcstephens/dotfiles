#!/usr/bin/env bb

;; require babashka process
(require '[babashka.process :refer [shell]]
         '[clojure.string :as str]
         '[babashka.cli :as cli]
         '[babashka.curl :as curl])

(def args (cli/parse-opts *command-line-args*))

(def git-email-set (-> (shell {:continue true :out nil} "git config user.email") :exit))

(def token (System/getenv "GIT_TOKEN"))

(when (nil? token)
  (println "GIT_TOKEN not set")
  (System/exit 1))

(when (not= git-email-set 0)
  (def remote (-> (shell {:out :string} "git remote get-url origin")
                  :out
                  str/split-lines
                  first
                  (str/replace #"https://" (str "https://" token "@"))))
  (shell "git remote set-url origin --push" remote)

  (shell "git config user.name Ruckus")
  (shell "git config user.email ruckus-ci@junco.dev"))

(defn post-pr [body]
  (curl/post "https://git.s.junco.dev/api/v1/repos/adam/dotfiles/pulls"
             {:form-params {"title" "Flake Update" "base" "main" "head" "update" "body" body}
              :headers {"Authorization" (format "token %s" token)}}))

(shell {:continue true} "git push origin --delete --force update")
(shell {:continue true} "git branch --delete --force update")
(shell "git switch --create update")

(defn nvd-diff [target]
  (shell "git stash")
  (def pre (-> (shell {:out :string} "nix build --print-build-logs --print-out-paths" target) :out str/split-lines first))
  (shell "git stash pop")
  (def post (-> (shell {:out :string} "nix build --print-build-logs --print-out-paths" target) :out str/split-lines first))
  (->> (shell {:out :string} "nvd diff" pre post) :out
       (format "## %s\n\n```\n%s\n```\n\n" target)))

(comment
  (defn nvd-diff [target]
    (format "```\n%s\n```" target)))

(shell "nix flake update")
(def diff (-> (shell {:continue true} "git diff --exit-code flake.lock") :exit))

(when (not= diff 1)
  (println "No changes to commit")
  (System/exit 0))

(def pr-body (->> [".#devShells.x86_64-linux.default" ".#home/config/blank"]
                  (map #(nvd-diff %))
                  (apply str)))

(println pr-body)

(if (get args :noop)
  (System/exit 0)
  (do (shell "git add flake.lock")
      (shell "git commit --message 'nix flake update'" (if (= git-email-set 0) "--gpg-sign" "--no-gpg-sign"))
      (shell "git push origin update")
      (post-pr pr-body)))


