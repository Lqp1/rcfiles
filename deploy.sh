#!/bin/bash

if [ -z "$@" ]
then
   echo "Please give at least one username"
   exit 0
fi

for i in $@
do
   if [ "$i" == "root" ]
   then
      echo "Furnishing '$i'"
      cp -vf "screenrc" "/root/.screenrc"
      cp -vf "vimrc" "/root/.vimrc"
      cp -vf "zshrc" "/root/.zshrc"
      cp -vf "bashrc" "/root/.bashrc"
      cp -vf "bashrc" "/root/.dircolors"
      cp -vf "zshenv" "/root/.zshenv"
   elif [ ! -d "/home/$i/" ]
   then
      echo "Directory home must be configured. Skipping."
   else
      echo "Furnishing '$i'"
      cp -vf "screenrc" "/home/$i/.screenrc"
      cp -vf "vimrc" "/home/$i/.vimrc"
      cp -vf "zshrc" "/home/$i/.zshrc"
      cp -vf "bashrc" "/home/$i/.bashrc"
      cp -vf "dircolors" "/home/$i/.dircolors"
      cp -vf "zshenv" "/home/$i/.zshenv"
      chown "$i:users" "/home/$i/.screenrc"
      chown "$i:users" "/home/$i/.vimrc"
      chown "$i:users" "/home/$i/.zshrc"
      chown "$i:users" "/home/$i/.bashrc"
      chown "$i:users" "/home/$i/.dircolors"
      chown "$i:users" "/home/$i/.zshenv"
   fi
done
echo "Done."
exit 1
