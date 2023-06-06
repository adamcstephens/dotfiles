#!/usr/bin/env bb

(require '[babashka.process :refer [shell]])
(require '[clojure.string :as str])
(require '[babashka.cli :as cli])
(require '[clojure.java.io :as io])

(def arg-parse (cli/parse-args *command-line-args* {:args->opts [:pr] :exec-args {:system ["aarch64-darwin" "x86_64-darwin"]} :require [:pr] :coerce {:system []}}))
(def args (get arg-parse :opts))
(def pull-request (get args :pr))

(def tempfile (-> (shell {:out :string} "mktemp" "/tmp/bb-build-pr.XXXXXX") :out str/split-lines first))
(def runner (str "cat report.md >> " tempfile))

(defn review [arch]
  (-> (shell {:out :string}
             "nixpkgs-review pr --run" runner "--system" arch pull-request)
      :out)
  (spit tempfile "\n-----\n\n" :append true))

(doall (map review (get args :system)))

(println (slurp tempfile))

(io/delete-file tempfile)
