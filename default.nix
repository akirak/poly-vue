{ pkgs ? import <nixpkgs> {}, emacs ? pkgs.emacs25 }:
let
  check-package = import (builtins.fetchGit {
    url = "https://github.com/akirak/emacs-package-checker";
    ref = "master";
    rev = "1553d9f6c8d61e8f455f22e4a1d0743bc8cd48a9";
  });
in check-package {
  inherit emacs pkgs;
  name = "emacs-poly-vue";
  src = ./.;
  targetFiles = ["poly-vue.el"];
  emacsPackages = epkgs: (with epkgs.melpaPackages; [
    polymode
  ]);
}
