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
	#Set password into encrypted file
	echo -n "Enter password: ";
	read -rs PASSWD
	sudo -k ; # Flush sudo session if any.
	echo $PASSWD | sudo -S echo &> /dev/null ;
	success_flag=$?;
	if [ $success_flag -eq 0 ];then
	    	echo $PASS openssl enc -aes-128-cbc -a -salt -pass pass:mysalt >> ~/.myencpswd;	
		echo "$_green Password updated. $_reset";
#Reference -https://unix.stackexchange.com/questions/291302/password-encryption-and-decryption	
else 
	    	echo "$_red Wrong password. Run update_pass again! $reset";
	fi
# ref: https://askubuntu.com/questions/611580/how-to-check-the-password-entered-is-a-valid-password-for-this-user	
}

first_time(){
	# Add source for subl, ref: http://tipsonubuntu.com/2017/05/30/install-sublime-text-3-ubuntu-16-04-official-way/
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update

	# Install all dependecies
	sudo apt-get install sublime-text tree xkbset xclip lolcat cowsay

update_pass();
}

# Note: PS1 is overridden by ~/.bashrc at last, so put these lines there (separately for each user, including root!):
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
# install cowsay for this - sudo apt-get install cowsay 
alias lc="ls -a | cowsay -n";
# if you want a lovely rainbow output, pipe it further to lolcat!
alias ls2="ls -a | cowsay -ne ❤❤ | lolcat";
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
alias mysql-login="mysql -u root -proot"; #configure your password
alias servepy="python3 -m http.server";
alias servepy2="python2.7 -m SimpleHTTPServer";


# These lines need to be in /etc/environment for all to work,
# using them here will not work while installing some packages like- phpstorm(or any snap package)
# export http_proxy="http://the17:the17@127.0.0.1:3128/";
# export https_proxy="http://the17:the17@127.0.0.1:3128/";

#### PIP Requirements ####
# all_proxy is required for pip! When it gives "Missing SOCK support" error-
export all_proxy="http://the17:the17@127.0.0.1:3128";


## HOMEs and PATHs
export CASSANDRA_HOME="/var/lib/cassandra"; # ="/usr/share/cassandra";
export NEO4J_HOME="/var/lib/neo4j";
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-9.0/lib64;
# export CUDA_HOME="/usr/local/cuda-9.0";
# export JAVA_HOME="/usr/lib/jvm/java-8-oracle";

# Some packages(like pyinstaller) get installed here- 
PATH=$PATH:$HOME/.local/bin
# For Composer packages (like laravel)
PATH=$PATH:$HOME/.config/composer/vendor/bin



#### Frequently used commands ####

alias install="sudo -S -E apt-get install";
alias update="sudo -S -E apt-get update";
alias autoremove="sudo -S -E apt-get autoremove";
alias removeapp="sudo -S -E apt-get remove";
alias purgeapp="sudo -S -E apt-get purge";

alias files="sudo -S -E nautilus /";
alias restart="sudo -S -E shutdown -r +0";
alias shutdown="sudo -S -E shutdown +0";
alias remount="sudo -S -E mount -o remount,rw";
#use gc to compile, use ./a to run compiled c program
alias gc="gcc -o a ";

#### USE FOLLOWING AFTER INSTALLING REQUIRED PACKAGES , eg 'sudo apt-get install xclip', #####

#this copies output of a file to clipboard (install xclip first)
alias c="xclip -selection clipboard";
alias v="xclip -o";

# TODO: Git clone from clipboard url (with validation)
# https://stackoverflow.com/questions/749544/pipe-to-from-the-clipboard-in-bash-script?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa


#### FILES RELATED #### 
# alias lstree="tree -L 1 --dirsfirst -rc"
#function to print directory tree upto input level $1
lstree(){
	tree -L $1 --dirsfirst -rc
}

#function to make dir and change to it immediately
mcd(){ -S
mkdir $1;
cd $1;
}
alias rmexecs="find . -type f -executable -exec rm '{}' \;"
#rm $(find . -type f | xargs file | grep "ELF.*shared object" | awk -F: '{print $1}' | xargs echo)

myclone(){
	# Put address to your repo here-
	git clone https://github.com/Udayraj123/$1
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
	fi;
	IFS=$oldIFS; 
	return $success_flag;

}
parse_squid(){
	parse_output 'squid.conf:\|Error:\|always_direct\|never_direct\|cache_peer\|$' sudo -S -E squid -k parse 2>&1;
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

# Service check/start/restart/stop
alias checkcass="sudo service cassandra status && sudo nodetool status";
alias startcass="sudo service cassandra status && sudo -u cassandra cassandra -f";
alias cqlshell="cqlsh --debug --color --request-timeout=30";

alias startneo4j="sudo -u neo4j neo4j console";
alias startneo4jbg="sudo -u neo4j neo4j start || sudo -u neo4j neo4j status";
alias checkneo4j="sudo -u neo4j neo4j status || sudo systemctl status neo4j";

# '&&' ensures to run second command only if first runs
alias resquid="parse_squid && execute_with_feedback sudo service squid restart && testnet";
alias reapache2="execute_with_feedback sudo service apache2 restart";

#Config files
alias bashrc="sudo -S -E subl /etc/bash.bashrc";
alias envfile="sudo -S -E subl /etc/environment";
alias dotbashrc="sudo -S -E subl $HOME/.bashrc";
alias aptconf="sudo -S -E subl /etc/apt/apt.conf"; 
alias apache2conf="sudo -S -E subl /etc/apache2/apache2.conf";
alias apache2defconf="sudo -S -E subl /etc/apache2/sites-available/000-default.conf";
alias apache2log="sudo -S -E subl /var/log/apache2/error.log";
#check if u need to replace squid with squid3
alias squidconf="sudo -S -E subl /etc/squid/squid.conf";
#also verify if passwd filename is squid_passwd,etc.
alias mksquidusr="sudo -S -E htpasswd -c /etc/squid/passwd ";

## Specific functions
clearcass(){
	CASSANDRA_HOME="/var/lib/cassandra";
	directories=$(find $CASSANDRA_HOME/data/ -mindepth 1 -maxdepth 1 -type d -not -name '\.*' -not -name 'system*');
	for dir in $directories; do
		echo "clean" $dir;
		sudo rm -rf $dir;
		sudo mkdir $dir;
	done;
	echo "Chown Chown";
	sudo chown -R cassandra:cassandra $CASSANDRA_HOME;
	ls $CASSANDRA_HOME/data;
}


# install xkbset first & enable "mouse keys" from Access Center
alias fastmouse="xkbset ma 60 10 100 100 2";
alias smoothmouse="xkbset ma 60 10 100 50 2";
alias kbmouse="xkbset q | grep Mouse"; #list mouse settings


### OTHERS ###
#lists all functions defined in this file
echo -n "${_bold}${_blue}Functions: $_reset$_magenta";
while read line; do 
    echo -ne $line,;
done < <(grep -o '^ *\w\w*()' /etc/bash.bashrc)
echo -ne "\n${_bold}${_blue}Aliases: $_reset$_green";
#lists all available aliases at start of terminal-
cat /etc/bash.bashrc | awk '{if($1=="alias")printf("%s,",$2);}' | awk -F= 'BEGIN{RS=",";}{printf("%s, ",$1);}END{;}';
echo "$_reset";

########################## password-typer alias: For people lazy to enter passwords- ##########################  
# The file is set from update_pass function.
# Comment this line if you don't want the password-typer feature:
alias s="echo $(cat ~/.myencpswd | openssl enc -d -aes-128-cbc -a -salt -pass pass:mysalt) |";
# ^Note : the pipe(|) at the end also prevents printing the password in terminal 
# 		  on pressing `s` or `s echo` (as echo doesn't read from stdin)

# Now just prepend an 's' before sudo -S -E to bypass - Example usage : 's sudo -S -E ..' or 's bashrc'
######  ##########################  ##########################  ##########################  


# Startup directory; useful sometimes
# Only if opened in HOME directory;
if [ "$PWD" == "$HOME" ] && [ $(whoami) != "root" ]; then
	cd $HOME/Downloads/coding;
	#cd $HOME/Desktop/;
fi


############## ############## ROUGH WORK ############## ##############
# export PROMPT_COMMAND="echo -n \[\$(date +%T)\]\ "; # PS1 method looks better.
# Somehow the Time Doesn't stick when used Ctrl+L tho

# PS1 is overridden by ~/.bashrc at last, so put these lines there:
# https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
# PS1 with a timestamp-
# export PS1='\e[0;49;33m[\D{%T}\[\]]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
# PS1 with command number,session seconds-
# export PS1='\e[0;49;33m(\!:$SECONDS)\[\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '


############## ############## BASH NOTES ############## ##############
# Why bash.bashrc over ~/.bashrc
# 	bash.bashrc Loads before ~/.bashrc (test by putting echo commands at start of each file),
#   and if you spawn a new shell(like zsh, or fish) the contents of ~/.bashrc won't be read.
# 	In other words, ~/.bashrc is only read when starting an interactive (non-login) shell. 
# 


# Note : sudo -S takes password from stdin! 
# Popular shells have a $SECONDS variable that stores no of seconds in the session.

# `test` string comparisions require a space in between!  if [ "$PWD" == "$HOME" ]; then
# watch -d=cumulative hightlights character-level changes, 


# '&&' ensures to run second command only if first runs
# One can see return status of previous command by echo $? (0 is success)

#Single quotes are not same as double quotes!
# https://stackoverflow.com/questions/23414407/bash-ps1-shows-instead-of-for-root

# Some string manipulations
# CURR_FILE=$(cat /etc/default/grub | grep BACKGROUND) # Get grub current line
# CURR_FILE=$(cut -d "=" -f 2 <<< "$CURR_FILE")        # File name only
# CURR_FILE=$(echo "$CURR_FILE" | tr -d '"')           # Remove double quotes

# echo -ne 'something\n' (-n will not output the trailing newline,-e will interpret backslash escape symbols)
# Use of curly brackets is to avoid spaces, can also use consecutive strings: 
#	 echo -n "${_green}Functions:""$_blue"; #when you dont want spaces


# Network manager cli to Up/Down a connection by name
# sudo nmcli con up my_vpn


#Bash quotes (in prog)-
# Single quotes (when not inside dbl quotes)
# 	> Doesn't evaluate variables.
# 	> Doesn't print the quotes

# Escaped Single quotes(when not inside dbl quotes)
# 	> Evaluates variables* and prints the quotes

# Double quotes
# 	> Evaluates variables and doesn't print the quotes


# Substrings in bash- ${my_string:2}
	# Args
	# https://stackoverflow.com/questions/9057387/process-all-arguments-except-the-first-one-in-a-bash-script
	# shift;COMMAND=$@; # More compatible
	# ${@:2} does not work in sh, only bash. this is called substring expansion and has a special behaviour for @.
	# usually it counts the characters, but for @ it counts the parameters
	# For sh, type the command 'shift', then $@ contains

# Remove previous entry from history-
# history -d $(history | tail -2 | head -1 |  awk '{print $1;}')
