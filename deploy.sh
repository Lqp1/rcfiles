#!/bin/bash

if [ -z $@  ]
then
   echo "Please give at least one username"
   exit 0
fi

for i in $@
do
   if [ ! -d "/home/$i/" ]
   then
      echo "Directory home must be configured. Skipping."
   else
      echo "Furnishing '$i'"
      cp -vi "screenrc" "/home/$i/.screenrc"
      cp -vi "vimrc" "/home/$i/.vimrc"
      cp -vi "zshrc" "/home/$i/.zshrc"
      cp -vi "bashrc" "/home/$i/.bashrc"
      chown "$i:users" "/home/$i/.screenrc"
      chown "$i:users" "/home/$i/.vimrc"
      chown "$i:users" "/home/$i/.zshrc"
      chown "$i:users" "/home/$i/.bashrc"
   fi
done
echo "Done."
exit 1
