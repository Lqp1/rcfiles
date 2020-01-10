rcfiles
=======

My personal RC files (zshrc, screenrc, vimrc...)

Note that the installation script installs
* oh-my-zsh and two plugins, then configures the template.
* spacemacs, then copies .spacemacs configuration file
* Copies configuration for vim, screen, bash and other...
* Adds one of my favorite git alias in global configuration.

>Usage:

>`git clone --recursive https://github.com/lqp1/rcfiles`

>`./deploy.sh myuser /home/myuser`


__NOTE__ : For `root` user, the script installs a minimal version, without oh my zsh and
spacemacs.
