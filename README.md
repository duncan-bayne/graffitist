# graffitist
Automate project-level tasks (e.g. ctags regeneration) when a buffer is saved.

## usage

Ensure that the path containing graffitist.el is in your load-path, then require it.  E.g.:

    (add-to-list 'load-path "~/graffitist")
    (require 'graffitist)

You can then create a `.graffitist` file in each project for which you want custom actions to be performed when a buffer is saved.

## example .graffitist file

Consider a Ruby project that uses [ripper-tags](https://github.com/tmm1/ripper-tags) to generate ctags.  You might create a .graffitist file in the root of the project directory that contains the following:

    (setq graffitist-rules
        '((".*\.rb" . (lambda (file-name project-dir-name) (shell-command "~/.rbenv/shims/ripper-tags -R ~/project -f ~/project/TAGS")))))

This specifies the action - in this case, a shell out to ripper-tags - to be executed when the filename of the saved buffer ends in `.rb`.

## FAQ

### are there any security issues?
graffitist is by design insecure; that is, it provides a mechanism for projects to specify arbitrary behaviour when buffers are saved.  [#3](https://github.com/duncan-bayne/graffitist/issues/3) is where I'm mulling this.  For now, caveat emptor, YMMV, etc.

### what defines a project?
A project is defined as the first directory up the hierarchy from the saved buffer that contains a .git directory.  If no such directory is found, the saved buffer is deemed not part of a project, and no action is performed.

## licence
The scripts unique to freebsd-setup are licensed under the GNU Lesser General Public License.

### why the LGPL?
The GPL is specifically designed to reduce the usefulness of GPL-licensed code to closed-source, proprietary software. The BSD license (and similar) don't mandate code-sharing if the BSD-licensed code is modified by licensees. The LGPL achieves the best of both worlds: an LGPL-licensed library can be incorporated within closed-source proprietary code, and yet those using an LGPL-licensed library are required to release source code to that library if they change it.
