{ pkgs ? import <nixpkgs> {},
  emacs ? (import (builtins.fetchTarball "https://github.com/purcell/nix-emacs-ci/archive/master.tar.gz")).emacs-25-2
}:
let
  check-package = import (builtins.fetchTarball "https://github.com/akirak/emacs-package-checker/archive/v1/master.tar.gz");
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
