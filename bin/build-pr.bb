#!/usr/bin/env bb

(require '[babashka.process :refer [shell]])
(require '[clojure.string :as str])
(require '[babashka.cli :as cli])
(require '[clojure.java.io :as io])

(def args (cli/parse-args *command-line-args* {:args->opts [:pr] :require [:pr]}))
(def pull-request (get (get args :opts) :pr))

(def tempfile (-> (shell {:out :string} "mktemp" "/tmp/bb-build-pr.XXXXXX") :out str/split-lines first))
(def runner (str "cat report.md >> " tempfile))

(def arches ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"])

(defn review [arch]
  (-> (shell {:out :string}
             "nixpkgs-review pr --run" runner "--system" arch pull-request)
      :out)
  (spit tempfile "\n-----\n\n" :append true))

(doall (map review arches))

(println (slurp tempfile))

(io/delete-file tempfile)
