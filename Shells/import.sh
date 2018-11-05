#!/bin/bash
if [ $EUID -ne 0 ]; then
	echo "Please run as root";
	exit 1;
fi
BASHRC_FILE="/etc/bash.bashrc"

# check if already copied!
echo "Checking if content already appended in '$BASHRC_FILE'...";
cat $BASHRC_FILE | grep -i --color "by Udayraj";
if [ "$?" == "0" ]; then
	echo -n "Seems like this file is already appended! Edit file [y/n]? ";
	read show;
	if [ "$show" == "y" ]; then
		sudo -E xdg-open $BASHRC_FILE;
		echo "If you've made any changes, you may run it again";
	fi
	exit 1;
fi

echo "Making backup..";
sudo cp $BASHRC_FILE $BASHRC_FILE.backup
echo "Appending..";
# https://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
cat ./appendThisTo.bashrc | sudo tee -a $BASHRC_FILE > /dev/null

echo "Done appending. Press enter to continue.";
read wait;

echo "Restarting bash..";
exec bash
