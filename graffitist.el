(defun graffitist-run-actions-for-file ()
  ""
  (let* ((filename (buffer-file-name (current-buffer)))
         (project-directory (graffitist--find-project-dir filename))
         (config-filename (graffitist--config-filename project-directory))
         (action (graffitist--find-action config-filename filename)))
    (if action
        (funcall action filename project-directory))))

(defun graffitist--find-project-dir (filename)
  (let ((directory-name (locate-dominating-file filename ".git")))
    (if directory-name
        (file-name-as-directory directory-name)
      nil)))

(defun graffitist--config-filename (project-directory)
  (if project-directory
      (concat project-directory ".graffitist")
    nil))

(defun graffitist--find-action (config-filename filename)
  (if (and config-filename (file-exists-p config-filename))
      (progn
        (load config-filename)
        (assoc-default filename graffitist-rules #'string-match))))

(add-hook 'after-save-hook #'graffitist-run-actions-for-file)

(provide 'graffitist)
