;;; anything-of-rails.el --- minor mode with anything for editing RubyOnRails code

;; refer to https://github.com/wolfmanjm/anything-on-rails.git

;; Copyright (C) 2011 Kazuya Yoshimi <kazuya dot yoshimi at gmail dot com>

(require 'anything)
(require 'find-cmd)

(eval-when-compile
  (require 'cl)
  (defvar recentf-list nil)
  (defvar rails-root nil))

(defun current-buffer-rails-root ()
  (let ((rails-project-root (locate-dominating-file default-directory "Gemfile")))
    (when (and rails-project-root
               (file-exists-p (concat rails-project-root "config/application.rb")))
      (expand-file-name rails-project-root))))


(defun rails-dirs (root dirs)
  (mapconcat (lambda (x) (if (file-directory-p x) x "" ))
             (mapcar (lambda (x) (concat root x)) dirs )
             " "))

(defun rails-c-make-displayable-names (path &optional dir)
  (mapcar
   (lambda (f)
     (cons
      (replace-regexp-in-string
       (concat "^" rails-root "\\(" (mapconcat 'identity dir "\\|") "\\)?/?")
       (lambda (s) (if (> (length s) (length rails-root)) "\\1 : " "/"))
       f)
      f))
   path))


(defvar rails-project-directories
  (list "app" "config" "spec" "db" "lib"))

(defvar omit-rails-project-directory-name
  (list
   "app/controllers" "app/models" "app/views" "app/helpers" "app/assets" "app/mailer" "app"
   "config"
   "db/migrate" "db"
   "spec/controllers" "spec/models" "spec/views" "spec/helpers" "spec"
   "lib"))


(defun rails-project-files ()
  (when rails-root
    (split-string
     (shell-command-to-string
      (concat "find " (rails-dirs rails-root rails-project-directories)
              " "
              (find-to-string `(or (name "*.rb" "*.erb" "*.js*" "*.css*" "*.yml"))))))))

(defun current-rails-recentf ()
  (when rails-root
    (loop for f in recentf-list
          when (string-match rails-root f)
          collect f)))

(defun rails-file-type (file)
  (cond
   ((string-match "/app/views/\\([a-zA-Z0-9_]+\\)/" file) "views")
   ((string-match "/app/controllers/.*/\\([a-zA-Z0-9_]+\\)_controller" file) "controllers")
   ((string-match "/app/models/" file) "models")
   ((string-match "/config/" file) "config")
   ((string-match "/spec/\\([a-zA-Z0-9_]+\\)/" file) (concat "spec-" (match-string 1 file)))
   ((string-match "/app/helpers/" file) "helper")
   ((string-match "/app/mailers/" file) "mailer")
   ((string-match "/app/\\([a-zA-Z0-9_]+\\)/" file) (match-string 1 file))
   (t "misc file")))

(defun controller-to-views (file)
  (replace-regexp-in-string "/controllers/\\(.*\\)_controller.rb" "/views/\\1" file))
(defun controller-to-helper (file)
  (replace-regexp-in-string "/controllers/\\(.*\\)_controller.rb" "/helpers/\\1_helper.rb" file))
(defun file-to-spec (file)
  (replace-regexp-in-string "/app/\\(.*\\).rb" "/spec/\\1_spec.rb" file))
(defun spec-to-file (file)
  (replace-regexp-in-string "/spec/\\(.*\\)_spec.rb" "/app/\\1.rb" file))
(defun view-to-controller (file)
  (replace-regexp-in-string "/views/\\(.*\\)/.*.erb" "/controllers/\\1_controller.rb" file))


(defun rails-current-actions ()
  (with-current-buffer anything-current-buffer
    (let ((actions ())
          (file buffer-file-name)
          (type (rails-file-type buffer-file-name)))
      (cond ((equal type "controllers")
             (add-to-list 'actions (cons "helper" (controller-to-helper file)))
             (add-to-list 'actions (cons "views" (controller-to-views file)))
             (add-to-list 'actions (cons "spec" (file-to-spec file))))
            ((equal type "models")
             (add-to-list 'actions (cons "spec" (file-to-spec file))))
            ((equal type "views")
             (add-to-list 'actions (cons "controller" (view-to-controller file))))
            ((equal type "spec-controllers")
             (add-to-list 'actions (cons "controller" (spec-to-file file))))
            ((equal type "spec-models")
             (add-to-list 'actions (cons "model" (spec-to-file file))))
             ))))


(defvar anything-c-source-rails-project-files
  '((name . "Project")
    (candidates . (lambda () (rails-project-files)))
    (candidate-transformer . (lambda (cands) (rails-c-make-displayable-names cands omit-rails-project-directory-name)))
    (candidate-number-limit . nil)
    (type . file)))

(defvar anything-c-source-rails-current-project-recentf
  '((name . "Recentf")
    (candidates . current-rails-recentf)
    (candidate-transformer . (lambda (cands) (rails-c-make-displayable-names cands)))
    (type . file)))

(defvar anything-c-source-rails-current-actions
  '((name . "Action in Rails Current Buffer")
    (candidates . (lambda () (rails-current-actions)))
    (type . file)))


(defun anything-of-rails ()
  (interactive)
  (let ((rails-root (current-buffer-rails-root)))
    (anything :sources '(anything-c-source-rails-current-actions
                         anything-c-source-rails-current-project-recentf
                         anything-c-source-rails-project-files)
              :prompt "Anything Of Rails: "
              :buffer "*anything-for-rails*")))


(provide 'anything-of-rails)
