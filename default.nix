{ pkgs ? import <nixpkgs> {}, emacs ? pkgs.emacs25 }:
let
  check-package = import (builtins.fetchGit {
    url = "https://github.com/akirak/emacs-package-checker";
    ref = "master";
    rev = "327d9ade9b2ea6a2f7799dcb1689865846dab1de";
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
