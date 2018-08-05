_black=$(tput setaf 0);	_red=$(tput setaf 1);
_green=$(tput setaf 2);	_yellow=$(tput setaf 3);
_blue=$(tput setaf 4);	_magenta=$(tput setaf 5);
_cyan=$(tput setaf 6);	_white=$(tput setaf 7);
_reset=$(tput sgr0);		_bold=$(tput bold);
update_pass(){
	if [ -f ~/.myencpswd ]; then 
		PASSWD=$(cat ~/.myencpswd | openssl enc -d -aes-128-cbc -a -salt -pass pass:mysalt);
		sudo -k ; 
		echo $PASSWD | sudo -S echo &> /dev/null ;
		success_flag=$?;
		if [ $success_flag -eq 0 ];then
			echo "$_green Password is already updated and working! $_reset";
			exit 0;
		fi
	fi
	echo -n "Enter password: ";
	read -rs PASSWD
	sudo -k ; # Flush sudo session if any.
	echo $PASSWD | sudo -S echo &> /dev/null ;
	success_flag=$?;
	if [ $success_flag -eq 0 ];then
    	echo $PASSWD | openssl enc -aes-128-cbc -a -salt -pass pass:mysalt > ~/.myencpswd;	
		echo "$_green Password is updated. $_reset";
	else 
	    	echo "$_red Wrong password. Run update_pass again! $reset";
	fi
	PASSWD= ;#reset var
}
first_time(){
	# configure text editor, machine name
	# install if sublime doesn't exist
	if ! ([ -x "$(command -v subl)" ] || [ -x "$(command -v sublime_text)" ]); then 
		sudo add-apt-repository ppa:webupd8team/sublime-text-3
		sudo apt-get update
		sudo apt-get install sublime-text-installer;
		# make it default
		echo
		echo "Replacing gedit with sublime as default editor..."
		sudo sed -i 's/gedit.desktop/sublime_text.desktop/g' /etc/gnome/defaults.list 
	fi	
	
	# Install all dependecies
	sudo apt-get install -y git tree xkbset xclip lolcat cowsay sox libsox-fmt-all
	# tree for lstree function
	# xkbset for mouse control via numpad
	# xclip can copy/paste from terminal
	# lolcat cowsay for fancy displaying.
	# sox libsox-fmt-all are needed for 'play' command
	
	if ! ([ -x "$(command -v git)" ]); then 
		git config --global credential.helper store;
		echo "Enter your github username: ";
		read GIT_USERNAME
	fi
	update_pass;
}
GIT_USERNAME=Udayraj123


#^ the \\$ at end is needed only if you use double quotes
alias sudo="sudo -E -S"; # Keep env same and accept password from stdin
alias ping="ping -R"; # Record route
alias locate="locate -b -r"; #Only basenames and regex
alias lc="ls -a | cowsay -n";
alias ls2="ls -a | cowsay -ne ❤❤ | lolcat";
alias watch="watch -d=cumulative"; # character level changes only
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
alias testnet="wget google.com -O /dev/null";
alias mysql-login="mysql -u root -proot"; #configure your password
alias servepy="python3 -m http.server";
alias servepy2="python2.7 -m SimpleHTTPServer";

export http_proxy="http://the17:the17@127.0.0.1:3128/";
export https_proxy="http://the17:the17@127.0.0.1:3128/";
#### PIP Requirements ####
export all_proxy="http://the17:the17@127.0.0.1:3128";
## HOMEs and PATHs
export CASSANDRA_HOME="/var/lib/cassandra"; # ="/usr/share/cassandra";
export NEO4J_HOME="/var/lib/neo4j";

PATH=$PATH:$HOME/.local/bin
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

#### FILES RELATED #### 
#function to print directory tree upto input level $1
lstree(){
	# shift;  COMMAND=$@; # More compatible
	COMMAND="$1 $2";	
	if [ "$COMMAND" == "" ]; then 
		COMMAND="2";
	fi;
	echo "$_magenta Running tree -L $COMMAND --dirsfirst -rc $_reset"
	tree -L $COMMAND --dirsfirst -rc
	echo "$_yellow Hint: use 'lstree <level> --du' to show directory sizes $_reset";
}
#function to make dir and change to it immediately
mcd(){ 
mkdir $1;
cd $1;
}
alias rmexecs="find . -type f -executable -exec rm '{}' \;"
#rm $(find . -type f | xargs file | grep "ELF.*shared object" | awk -F: '{print $1}' | xargs echo)
showalias(){ # expand keyword is taken
	cat /etc/bash.bashrc | grep -iE -A $2 "alias $1 ?=";
}
myclone(){
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
alias checkcass="sudo service cassandra status && sudo nodetool status";
alias startcass="sudo service cassandra status && sudo -u cassandra cassandra -f";
alias cqlshell="cqlsh --debug --color --request-timeout=30";
alias startneo4j="sudo -u neo4j neo4j console";
alias startneo4jbg="sudo -u neo4j neo4j start || sudo -u neo4j neo4j status";
alias checkneo4j="sudo -u neo4j neo4j status || sudo systemctl status neo4j";
alias resquid="parse_squid && execute_with_feedback sudo service squid restart && testnet";
alias reapache2="execute_with_feedback sudo service apache2 restart";
alias rebash="exec bash";
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
alias fastmouse="xkbset ma 60 10 100 100 2";
alias smoothmouse="xkbset ma 60 10 100 50 2";
alias kbmouse="xkbset q | grep Mouse"; #list mouse settings
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
echo -ne "\n${_bold}${_blue}System: $_reset$_yellow";
lsb_release -d | awk '{$1="";print $0}'
echo -ne "$_reset";
########################## password-typer alias: For people lazy to enter passwords- ##########################  
if [ ! -f ~/.myencpswd ]; then 
	# The file is set from update_pass function.
	echo "Password file not set. Set the password to continue:";
	update_pass;
fi
alias s="echo $(cat ~/.myencpswd | openssl enc -d -aes-128-cbc -a -salt -pass pass:mysalt) |";


if [ "$PWD" == "$HOME" ] && [ $(whoami) != "root" ]; then
	if [ -d $HOME/Downloads/coding ];then 
		cd $HOME/Downloads/coding;
	else
		cd $HOME/Desktop/;
	fi
fi
