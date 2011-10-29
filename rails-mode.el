;;; Rails minor mode

(define-minor-mode rails-minor-mode
  "RubyOnRails"
  nil
  " RoR")
;  rails-minor-mode-map
;  (abbrev-mode -1)
;  (make-local-variable 'tags-file-name)
;  (make-local-variable 'rails-primary-switch-func)
;  (make-local-variable 'rails-secondary-switch-func))
  ;; (rails-features:install))

;; hooks

;; (add-hook 'ruby-mode-hook
;;           (lambda()
;;             (require 'rails-ruby)
;;             (require 'ruby-electric)
;;             (ruby-electric-mode (or rails-enable-ruby-electric -1))
;;             (ruby-hs-minor-mode t)
;;             (imenu-add-to-menubar "IMENU")
;;             (modify-syntax-entry ?! "w" (syntax-table))
;;             (modify-syntax-entry ?: "w" (syntax-table))
;;             (modify-syntax-entry ?_ "w" (syntax-table))
;;             (local-set-key (kbd "C-.") 'complete-tag)
;;             (local-set-key (if rails-use-another-define-key
;;                                (kbd "TAB") (kbd "<tab>"))
;;                            'indent-and-complete)
;;             (local-set-key (rails-key "f") '(lambda()
;;                                               (interactive)
;;                                               (mouse-major-mode-menu (rails-core:menu-position))))
;;             (local-set-key (kbd "C-:") 'ruby-toggle-string<>simbol)
;;             (local-set-key (if rails-use-another-define-key
;;                                (kbd "RET") (kbd "<return>"))
;;                            'ruby-newline-and-indent)))


;; (add-hook 'find-file-hooks
;;           (lambda()
;;             (rails-project:with-root
;;              (root)
;;              (progn
;;                (local-set-key (if rails-use-another-define-key
;;                                   (kbd "TAB") (kbd "<tab>"))
;;                               'indent-and-complete)
;;                (rails-minor-mode t)
;;                (rails-apply-for-buffer-type)))))

;; Run rails-minor-mode in dired

;; (add-hook 'dired-mode-hook
;;           (lambda ()
;;             (if (rails-project:root)
;;                 (rails-minor-mode t))))

(provide 'rails-mode)