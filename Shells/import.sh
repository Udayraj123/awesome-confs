#!/bin/bash
if [ $EUID -ne 0 ]; then
	echo "Please run as root";
	exit 1;
fi
BASHRC_FILE="/etc/bash.bashrc"

# check if already copied!
cat $BASHRC_FILE | grep -i "<<< Made with ♥ by Udayraj >>>";
if [ $? -e 0 ]; then
	echo "Seems like the file is already appended! Show file [y/n]? ";
	read show;
	if [ $show -e "n" ]; then
		exit 1;
	else
		sudo -E xdg-open $BASHRC_FILE;
	fi
fi

echo "Making backup..";
sudo cp $BASHRC_FILE $BASHRC_FILE.backup
echo "Appending..";
# https://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
cat ./appendThisTo.bashrc | sudo tee -a $BASHRC_FILE

echo "Restarting bash..";
exec bash