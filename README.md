rcfiles
=======

My personal RC files (zshrc, screenrc, vimrc, i3...)

This repository contains 4 Ansible roles:
* gentoo: will install some useful gentoo tools and setup local repository
* common: will install/configure command line tools
  - FZF
  - Spacemacs
  - Oh-My-ZSH and plugins
  - Screen, VIM, Bash, ZSH
  - Some aliases
  - Git config
  - Curl config
* common-ui: will install/configure some UI (i3, polybar, splatmoji, gtk config, ...)
  - i3 + i3autotiling
  - Splatmoji
  - Polybar
  - Rofi theme (xresources)
  - GTK 2+3 config
  - Some fonts for Polybar
* user: will setup more personnal things, like samba shares, install some python
packages/gems, ...

Actual rcfiles are in `roles/common/files/` and in `roles/common-ui/files/`.

Usage:
```bash
git clone --recursive https://github.com/lqp1/rcfiles
vim host_vars/localhost.yml

# To set everything for the user:
ansible-playbook deploy.yml

# To setup root user config and gentoo:
sudo ansible-playbook deploy.yml
sudo ansible-playbook gentoo.yml
```

__NOTE__ : When running with `minimal:true` the script installs a minimal and lighter version,
without oh my zsh, fzf, splamoji, and spacemacs and no UI config

__Credits__:
* Polybar theme comes from https://github.com/adi1090x/polybar-themes; slightly
  modified.
* res/fonts/* are not mine, all credit go to their respective author.
