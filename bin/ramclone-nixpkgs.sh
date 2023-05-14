#!/usr/bin/env sh

set -ex

[ ! -e "$XDG_RUNTIME_DIR/git/nixpkgs" ] || exit 0

[ -e ~/git/nixpkgs ]

cd "$XDG_RUNTIME_DIR"
mkdir -vp git
cd git

rsync -a ~/git/nixpkgs ./

cd nixpkgs
echo "use flake ~/.dotfiles#nixpkgs" >.envrc
direnv allow

git remote remove origin
git remote remove upstream
git remote add origin https://github.com/adamcstephens/nixpkgs.git
git remote add upstream https://github.com/NixOS/nixpkgs.git

git fetch upstream
git switch master --force
git reset --hard upstream/master
git pull --set-upstream upstream master

gh repo set-default nixos/nixpkgs
