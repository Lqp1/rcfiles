rcfiles
=======

# Summary

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

# Usage

```bash
git clone --recursive https://github.com/lqp1/rcfiles
vim host_vars/localhost.yml
echo '---' > host_vars/vault.yml # contains only my overrides

# To set everything for the user:
ansible-playbook deploy.yml --ask-vault-pass

# To setup gentoo config:
ansible-playbook gentoo.yml -K --ask-vault-pass

# Adapt to the sets you're interested in:
echo -e "@personal\n@personalLaptop\n@personalX11\n" | sudo tee -a /var/lib/portage/world_sets
```

__NOTE__ : When running with `minimal:true` the script installs a minimal and lighter version,
without oh my zsh, fzf, splamoji, and spacemacs and no UI config

# Screenshots

Some screenshots of the features it sets up:

<img src="https://github.com/lqp1/rcfiles/blob/master/doc/screenshot.png?raw=true" alt="i3 and polybar setup" width="250"/>

<img src="https://github.com/lqp1/rcfiles/blob/master/doc/screenshot2.png?raw=true" alt="exa listing" width="250"/>

<img src="https://github.com/lqp1/rcfiles/blob/master/doc/screenshot3.png?raw=true" alt="vgrep and fzf setup" width="250"/>

# Credits

* Polybar theme comes from https://github.com/adi1090x/polybar-themes; slightly
  modified.
* Fonts owner! (in particular Noto, Iosevka, Fira-code and Nerd Fonts)
