{ pkgs ? import <nixpkgs> {} }:
let
  check-package = import (builtins.fetchTarball "https://github.com/akirak/emacs-package-checker/archive/master.tar.gz");
  emacs-ci = import (builtins.fetchTarball "https://github.com/purcell/nix-emacs-ci/archive/master.tar.gz");
  emacs = emacs-ci.emacs-25-2;
  emacs-workarounded = emacs // {
    meta = emacs.meta // { platforms = pkgs.stdenv.lib.platforms.all; };
  };
in check-package {
  inherit pkgs;
  name = "emacs-poly-vue";
  src = ./.;
  targetFiles = ["poly-vue.el"];
  emacsPackages = epkgs: (with epkgs.melpaPackages; [
    polymode
  ]);
  emacs = emacs-workarounded;
}
