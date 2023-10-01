(require 'package)
 
;;(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
 
(setq package-enable-at-startup nil)
(package-initialize)

(org-babel-load-file "~/.config/homemadeconfig/emacs/config.org")

