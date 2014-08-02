#!/bin/bash

if [ -z "$@"  ]
then
   echo "Please give at least one username"
   exit 0
fi

for i in $@
do
   if [ "$i" == "root" ]
   then
      echo "Furnishing '$i'"
      cp -vi "screenrc" "/root/.screenrc"
      cp -vi "vimrc" "/root/.vimrc"
      cp -vi "zshrc" "/root/.zshrc"
      cp -vi "bashrc" "/root/.bashrc"
      cp -vi "bashrc" "/root/.dircolors"
   elif [ ! -d "/home/$i/" ]
   then
      echo "Directory home must be configured. Skipping."
   else
      echo "Furnishing '$i'"
      cp -vi "screenrc" "/home/$i/.screenrc"
      cp -vi "vimrc" "/home/$i/.vimrc"
      cp -vi "zshrc" "/home/$i/.zshrc"
      cp -vi "bashrc" "/home/$i/.bashrc"
      cp -vi "dircolors" "/home/$i/.dircolors"
      chown "$i:users" "/home/$i/.screenrc"
      chown "$i:users" "/home/$i/.vimrc"
      chown "$i:users" "/home/$i/.zshrc"
      chown "$i:users" "/home/$i/.bashrc"
      chown "$i:users" "/home/$i/.dircolors"
   fi
done
echo "Done."
exit 1
