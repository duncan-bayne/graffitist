(defun graffitist--run-actions-for-file ()
  "Runs the action specified in the project .graffitist file for the filename of the current buffer, if any."
  (let* ((filename (buffer-file-name (current-buffer)))
         (project-directory (graffitist--find-project-dir filename))
         (config-filename (graffitist--config-filename project-directory))
         (action (graffitist--find-action config-filename filename)))
    (if action
        (funcall action filename project-directory))))

(defun graffitist--find-project-directory (filename)
  "Finds the project directory for the specified filename.  Returns nil if there is no project directory.
The project directory is defined as the first directory upwards in the hierarchy containing .git."
  (let ((directory-name (locate-dominating-file filename ".git")))
    (if directory-name
        (file-name-as-directory directory-name)
      nil)))

(defun graffitist--config-filename (project-directory)
  "Returns the filename to the .graffitist configuration file for the specified project directory."
  (if project-directory
      (concat project-directory ".graffitist")
    nil))

(defun graffitist--find-action (config-filename filename)
  "Finds the first action associated with a regex that matches filename."
  (if (and config-filename (file-exists-p config-filename))
      (progn
        (load config-filename)
        (assoc-default filename graffitist-rules #'string-match))))

(add-hook 'after-save-hook #'graffitist--run-actions-for-file)
(provide 'graffitist)
