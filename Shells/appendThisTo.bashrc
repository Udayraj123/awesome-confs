############## ############## AWESOME-BASHRC CODE BELOW ############## ##############
# <<< Made with ♥ by Udayraj >>>



# set these variables to customize:
TEXT_EDITOR=subl
GIT_USERNAME=udayraj123
SQUID_PROXY_ON=0



# Sequence of text colors : black (0), red, green, yellow, blue, magenta, cyan,white
# https://ss64.com/bash/syntax-prompt.html
_black=$(tput setaf 0);	_red=$(tput setaf 1);
_green=$(tput setaf 2);	_yellow=$(tput setaf 3);
_blue=$(tput setaf 4);	_magenta=$(tput setaf 5);
_cyan=$(tput setaf 6);	_white=$(tput setaf 7);
_reset=$(tput sgr0);		_bold=$(tput bold);
# ^Above can be used anywhere in printable strings in bash(examples below)(Not in awk's internal printf and the alike).
# Syntax guide: Each color only marks the start of that color(see examples below)

update_pass(){
	# check if existing password works
	if [ -f ~/.myencpswd ]; then 
		PASSWD=$(cat ~/.myencpswd | openssl enc -d -aes-128-cbc -a -salt -pass pass:mysalt);
		sudo -k ; # Flush sudo session if any.
		echo $PASSWD | sudo -S echo &> /dev/null ;
		success_flag=$?;
		if [ $success_flag -eq 0 ];then
			echo "$_green Password is already updated and working! $_reset";
			return 0;
		fi
	fi
	#Set password into encrypted file
	echo -n "Enter password: ";
	read -rs PASSWD
	sudo -k ; # Flush sudo session if any.
	echo $PASSWD | sudo -S echo &> /dev/null ;
	success_flag=$?;
	if [ $success_flag -eq 0 ];then
    	echo $PASSWD | openssl enc -aes-128-cbc -a -salt -pass pass:mysalt > ~/.myencpswd;	
		echo "$_green Password is updated. $_reset";
	else 
	    	echo "$_red Wrong password. Run update_pass again! $_reset";
	fi
	PASSWD= ;#reset var
# References: https://unix.stackexchange.com/questions/291302/password-encryption-and-decryption	
# 			  https://askubuntu.com/questions/611580/how-to-check-the-password-entered-is-a-valid-password-for-this-user	
}

# This should be re-runnable
first_time(){
	# configure text editor, machine name

	# install if sublime doesn't exist
        # Note: For latest method of installation go here - https://www.sublimetext.com/docs/3/linux_repositories.html#apt
#	if ! ([ -x "$(command -v subl)" ] || [ -x "$(command -v sublime_text)" ]); then 
#		sudo add-apt-repository ppa:webupd8team/sublime-text-3
#		sudo apt-get update
#		sudo apt-get install sublime-text-installer;
#		# make it default
#		echo
#		echo "Replacing gedit with sublime as default editor..."
#		sudo sed -i 's/gedit.desktop/sublime_text.desktop/g' /etc/gnome/defaults.list 
#	fi	
	
	# Install all dependecies
	sudo apt-get install -y git tree xkbset xclip lolcat cowsay sox libsox-fmt-all apache2-utils
	# tree for lstree function
	# xkbset for mouse control via numpad
	# xclip can copy/paste from terminal
	# lolcat cowsay for fancy displaying.
	# sox libsox-fmt-all are needed for mp3 support in notifications ('play' command)
	# apache2-utils needed for htpasswd

	
	if ([ -x "$(command -v git)" ]); then 
		echo "Configure your github details(for git utilities)";
		echo "$_green Enter your github username: ";
		read GIT_USERNAME;
		git config --global user.name $GIT_USERNAME;
		echo "$_green Enter your github email: ";
		read GIT_EMAIL;
		git config --global user.email $GIT_EMAIL;

		# Some rather useful configurations (provided its your personal PC)
		echo "$_green Do you want github to remember your password?(y/n)$_reset";
		read tempinp;
		if [ "$tempinp" == "y" ]; then
			git config --global credential.helper store;
		fi
		echo "Adding alias: 'add-commit'"
		git config --global alias.add-commit '!git add . && git commit -m ';
		echo "(Usage: git add-commit 'commit message')"
	fi
	echo "$_greenWant to set RTC in local time(To fix time difference prob with dual boot)?(y/n) $_reset";
	read tempinp;
	if [ "$tempinp" == "y" ]; then
		timedatectl set-local-rtc 1 --adjust-system-clock;
		timedatectl | grep -E "^|RTC in local TZ:";
		echo "$_green Done :) Check the clock now... $_reset";
	fi
	echo "Moving on...";
	echo "Updating locate command's filesystem database...";
	sudo updatedb
	echo "Updating password..."
	update_pass;
}

# Note: Put these lines into ~/.bashrc. Because PS1 is overridden there after this file,
# Or you can comment the lines there, then uncomment here!

# PS1 with a timestamp-
# export PS1='\[$_yellow\][\D{%T}]\[$_magenta\]\u\[$_green\]@\h\[$_reset\]:\[$_bold\]\[$_blue\]\W\[$_reset\]\\$ ';
# PS1 with command number,session seconds-
# export PS1='\[$_yellow\](\!:$SECONDS)\[$_magenta\]\u\[$_green\]@\h\[$_reset\]:\[$_bold\]\[$_blue\]\W\[$_reset\]\\$ ';
#^ the \\$ at end is needed only if you use double quotes

# Overridden Commands
alias sudo="sudo -E -S"; # Keep env same and accept password from stdin
alias ping="ping -R"; # Record route
alias locate="locate -b -r"; #Only basenames and regex
alias ls2="lstree";
# install cowsay for this - sudo apt-get install cowsay 
alias ls3="ls -a | cowsay -n";
# if you want a lovely rainbow output, pipe it further to lolcat!
alias ls4="ls -a | cowsay -ne ❤❤ | lolcat";
# ^ https://www.tecmint.com/lolcat-command-to-output-rainbow-of-colors-in-linux-terminal/
alias watch="watch -d=cumulative"; # character level changes only

# for line level changes-
watchDiff(){ 
	# Do not pass commands like 'top', they don't work with watch either
	COMMAND=$@;
	while true; do 
	p1=$p2; 
	p2=$(clear; $COMMAND);
	dwdiff -y "\010" -1 -c <(echo "$p1") <(echo "$p2");
	sleep 2; 
	done;
}


# Network
alias testnet="wget google.com -O /dev/null";
alias servepy="python3 -m http.server";
# alias servepy2="python2.7 -m SimpleHTTPServer";


# These lines best be in /etc/environment for all types of pkg to work,
# using them here will not work while installing snap packages like phpstorm
if [[ "$SQUID_PROXY_ON" == "1" ]]; then
	export http_proxy="http://the17:the17@127.0.0.1:3128/";
	export https_proxy="http://the17:the17@127.0.0.1:3128/";

	#### PIP Requirements ####
	# all_proxy is required for pip! When it gives "Missing SOCK support" error-
	export all_proxy="http://the17:the17@127.0.0.1:3128";
fi


## HOMEs and PATHs

# Some packages(like pyinstaller) get installed here- 
PATH=$PATH:$HOME/.local/bin
# cowsay gets here
PATH=$PATH:/usr/games
# For Composer packages (like laravel)
PATH=$PATH:$HOME/.config/composer/vendor/bin



#### Frequently used commands ####

alias install="sudo -S -E apt-get install";
alias update="sudo -S -E apt-get update";

alias explorer="sudo -S -E nautilus /";
alias restart="sudo -S -E shutdown -r +0";
alias shutdown="sudo -S -E shutdown +0";
# For issues accessing windows drives -
# alias remount="sudo -S -E mount -o remount,rw";

#use gc to compile, use ./a to run compiled c program
alias gc="gcc -o a ";

#### USE FOLLOWING AFTER INSTALLING REQUIRED PACKAGES , eg 'sudo apt-get install xclip', #####

#this copies output of a file to clipboard (install xclip first)
alias c="xclip -selection clipboard";
alias v="xclip -o";

# TODO: Git clone from clipboard url (with validation)
# https://stackoverflow.com/questions/749544/pipe-to-from-the-clipboard-in-bash-script
# ^ xclip would do it


#### FILES RELATED #### 
# alias lstree="tree -L 1 --dirsfirst -rc"
#function to print directory tree upto input level $1
lstree(){
	# shift;  COMMAND=$@; # More compatible
	COMMAND="$1 $2";		
	if ([ "$COMMAND" == " " ] || [ "$COMMAND" == "" ]); then 
		COMMAND="2";
	fi
	echo "$_magenta Running tree -L $COMMAND --dirsfirst -rc $_reset"
	tree -L $COMMAND --dirsfirst -rc
	echo "$_yellow Hint: use 'lstree <level> --du' to show directory sizes $_reset";
}


#function to make dir and change to it immediately
mcd(){ 
mkdir $1;
cd $1;
}

# One usecase in competitive programming- to delete all .out files and alike from current directory
alias rmexecs="find . -type f -executable -exec rm '{}' \;"
#rm $(find . -type f | xargs file | grep "ELF.*shared object" | awk -F: '{print $1}' | xargs echo)

# find declaration of some alias - 
# Inbuilt alias keyword also does this-  usage: 'alias my_alias' !!
showalias(){ # expand keyword is taken
	cat /etc/bash.bashrc | grep -iE -A $2 "alias $1 ?=";
}

myclone(){
# Usage : 'git clone https://github.com/yourusername/reponame' will become  'myclone reponame'
	git clone https://github.com/$GIT_USERNAME/$1
}
parse_output(){
	# NOTE: Commands with quotes won't preserve their quotes here (impossible in bash)
	# https://stackoverflow.com/questions/3260920/preserving-quotes-in-bash-function-parameters

	# Splitting args
	pattern=$1;
	# COMMAND=${@:2};	
	shift;  COMMAND=$@; # More compatible
	echo "Running '$COMMAND'..." ;
	
	# Preserving newlines in command output-
	# https://unix.stackexchange.com/questions/164508/why-do-newline-characters-get-lost-when-using-command-substitution
	oldIFS=$IFS;
	IFS=;

	output=$(eval $COMMAND);
	success_flag=$?;
	
	# TODO: Fix this line-
	echo $output | grep -i --color "'$pattern'"; 

	echo;
	if [ $success_flag -eq 0 ];then
		echo "$_green Output Successfully parsed. $_reset";
	else
		echo "$_red There was some error found in the output($success_flag). Check and try again. $_reset";
	fi
	IFS=$oldIFS; 
	return $success_flag;
}
parse_squid(){
	parse_output 'squid.conf:\|Error:\|always_direct\|deny\|never_direct\|cache_peer\|$' sudo -S -E squid -k parse 2>&1;
}
execute_with_feedback(){
	COMMAND=$@;
	play -q ~/Music/Notify.mp3;
	echo "Running '$COMMAND'..." ;
	notify-send "Running Command..." "'$COMMAND'";
	start=`date +%s`;
	out=`$COMMAND; echo $?`;
	end=`date +%s`;
	runtime=$((end-start));
	if [ $out -ne 0 ]; then 
		notify-send "Command Failed after $runtime seconds!" "'$COMMAND'"
	else
		notify-send "It took $runtime seconds!" "Successfully Ran: '$COMMAND'";
	fi
	play -q ~/Music/Notify.mp3 reverse;
}

# '&&' ensures to run second command only if first runs
alias resquid="parse_squid && execute_with_feedback sudo service squid restart && testnet";
alias rebash="exec bash";

#Config files
alias bashrc="sudo -S -E $TEXT_EDITOR /etc/bash.bashrc";
alias envfile="sudo -S -E $TEXT_EDITOR /etc/environment";
alias dotbashrc="sudo -S -E $TEXT_EDITOR $HOME/.bashrc";
alias aptconf="sudo -S -E $TEXT_EDITOR /etc/apt/apt.conf"; 

#check if u need to replace squid with squid3
alias squidconf="sudo -S -E $TEXT_EDITOR /etc/squid/squid.conf";
#also verify if passwd filename is squid_passwd,etc. (needs apache2-utils installed)
alias mksquidusr="sudo -S -E htpasswd -c /etc/squid/passwd ";

### Things related to this file ###

## STARTUP LINES PRINTED FROM HERE 

#lists all functions defined in this file
echo -n "${_bold}${_blue}Functions: $_reset$_magenta";
while read line; do 
    echo -ne $line,;
done < <(grep -o '^ *\w\w*()' /etc/bash.bashrc)

#lists all available aliases at start of terminal-
echo -ne "\n${_bold}${_blue}Aliases: $_reset$_green";
cat /etc/bash.bashrc | awk '{if($1=="alias")printf("%s,",$2);}' | awk -F= 'BEGIN{RS=",";}{printf("%s, ",$1);}END{;}';
echo -n "$_reset";
 
# Print system and version (Comment these two lines if not wanted)
echo -ne "\n${_bold}${_blue}System: $_reset$_yellow";
lsb_release -d | awk '{$1="";print $0}'
echo -ne "$_reset";

########################## password-typer alias: For people lazy to enter passwords- ##########################  
if [ ! -f ~/.myencpswd ]; then 
	# The file is set from update_pass function.
	echo "Password file not set. Set the password to continue:";
	update_pass;
fi
# Comment the line below if you don't want the password-typer feature:
alias s="echo $(cat ~/.myencpswd | openssl enc -d -aes-128-cbc -a -salt -pass pass:mysalt) |";
# ^Note : the pipe(|) at the end also prevents printing the password in terminal 
# 		  on pressing `s` or `s echo` (as echo doesn't read from stdin)
# HOW TO USE: 
# Now just prepend an 's' before sudo -S -E to bypass - Example usage : 's sudo -S -E ..' or 's bashrc'


# Startup directory; 
# Changes directory only when opened in HOME (not when in other specific folder);
if [ "$PWD" == "$HOME" ] && [ $(whoami) != "root" ]; then
	if [ -d $HOME/Downloads/coding ];then 
		cd $HOME/Downloads/coding;
	else
		# Type your default startup directory
		cd $HOME;
		# cd $HOME/Desktop/;
	fi
fi

# <<< Made with ♥ by Udayraj >>>
