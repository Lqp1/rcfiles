rcfiles
=======

My personal RC files (zshrc, screenrc, vimrc, i3...)

Note that the installation script installs
* oh-my-zsh and two plugins, then configures the template.
* spacemacs, then copies .spacemacs configuration file
* Copies configuration for vim, screen, bash and other...
* Adds one of my favorite git alias in global configuration.
* FZF
* splatmoji

Actual rcfiles are in `roles/rcfiles/files/`

>Usage:

>`vim host_vars/localhost.yml` (tweak parameters)

>`git clone --recursive https://github.com/lqp1/rcfiles`

>`sudo ansible-playbook gentoo.yml` (will bootstrap other needed binaries in
Gentoo)`

Then use ansible-playbook to deploy, overriding some variables:

> `ansible-playbook --extra-vars "{'user':\"myuser\"}" deploy.yml`
> `sudo ansible-playbook --extra-vars "{'user':\"root\",'home':\"/root\",'minimal':true}" deploy.yml`


__NOTE__ : When running with `minimal:true` the script installs a minimal and lighter version,
without oh my zsh, fzf, splamoji, and spacemacs.
