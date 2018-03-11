(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(custom-set-variables
 '(package-selected-packages (quote (evil))))
(custom-set-faces
 )
(require 'evil)
  (evil-mode 1)

(setq tramp-default-method "ssh")
(set-language-environment "UTF-8")
(column-number-mode t)
(setq ring-bell-function 'ignore)
(load-theme 'wombat)
