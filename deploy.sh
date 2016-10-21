#!/bin/bash

FILES="screenrc vimrc zshrc bashrc dircolors zshenv"
DIRS=".cache .cache/zsh .vimdat"

function copyfiles {
TARGETUSER=${1}
USERHOME=$(eval echo "~${TARGETUSER}")

if [ -z "$(getent passwd|grep ${TARGETUSER})" ]
then
   echo "User ${TARGETUSER} not found..."
   return 1
fi
if [ -z "$USERHOME" ]
then
   echo "User ${TARGETUSER} not found..."
   return 1
fi

echo "    -> Home ${USERHOME}"
for f in ${FILES}
do
   cp -vf "${f}" "${USERHOME}/.${f}"
   chown "${TARGETUSER}:users" "${USERHOME}/.${f}"
done
for d in ${DIRS}
do
   if [ ! -d "${USERHOME}/${d}" ]
   then
      mkdir "${USERHOME}/${d}"
      chown "${TARGETUSER}:users" "${USERHOME}/${d}"
   fi
done
return 0
}

if [ -z "$@" ]
then
   echo "Please give at least one username"
   exit 1
fi

for i in $@
do
   echo "-> User $i"
   copyfiles ${i}
done
echo "Done."
exit 0
