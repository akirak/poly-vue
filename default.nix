{ pkgs ? import <nixpkgs> {} }:
let
  check-package = import (builtins.fetchGit {
    url = "https://github.com/akirak/emacs-package-checker";
    ref = "master";
    rev = "1553d9f6c8d61e8f455f22e4a1d0743bc8cd48a9";
  });
  emacs-ci = import (builtins.fetchUrl "https://github.com/purcell/nix-emacs-ci/archive/master.tar.gz");
in check-package {
  inherit pkgs;
  name = "emacs-poly-vue";
  src = ./.;
  targetFiles = ["poly-vue.el"];
  emacsPackages = epkgs: (with epkgs.melpaPackages; [
    polymode
  ]);
  emacs = emacs-ci.emacs-25-1;
}
