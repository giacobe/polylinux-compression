#!/bin/sh
PS1='\W$ '
cd "$HOME" || exit 1
clear
echo "************************************************************************"
echo "* Welcome to Compression Bandit. Read README.txt to begin.             *"
echo "* Submit answers to the exercise grader.                               *"
echo "* Move with nextlevel and prevlevel.                                   *"
echo "************************************************************************"
cat README.txt
