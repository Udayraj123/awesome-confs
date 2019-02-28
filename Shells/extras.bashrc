
# Extra aliases - 
# alias mysql-login="mysql -u root -proot"; #configure your password
# alias apache2conf="sudo -S -E $TEXT_EDITOR /etc/apache2/apache2.conf";
# alias apache2defconf="sudo -S -E $TEXT_EDITOR /etc/apache2/sites-available/000-default.conf";
# alias apache2log="sudo -S -E $TEXT_EDITOR /var/log/apache2/error.log";
# alias reapache2="execute_with_feedback sudo service apache2 restart";

# For below - install xkbset first(run first_time) & enable "mouse keys" from Access Center
# alias fastmouse="xkbset ma 60 10 100 100 2";
# alias smoothmouse="xkbset ma 60 10 100 50 2";
# alias kbmouse="xkbset q | grep Mouse"; #list mouse settings


# alias autoremove="sudo -S -E apt-get autoremove";
# alias removeapp="sudo -S -E apt-get remove";
# alias purgeapp="sudo -S -E apt-get purge";


## HOMEs and PATHs
# export CASSANDRA_HOME="/var/lib/cassandra"; # ="/usr/share/cassandra";
# export NEO4J_HOME="/var/lib/neo4j";
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-9.0/lib64;
# export CUDA_HOME="/usr/local/cuda-9.0";
# export JAVA_HOME="/usr/lib/jvm/java-8-oracle";

###### Specific to some software
# Service check/start/restart/stop
alias checkcass="sudo service cassandra status && sudo nodetool status";
alias startcass="sudo service cassandra status && sudo -u cassandra cassandra -f";
alias cqlshell="cqlsh --debug --color --request-timeout=30";

alias startneo4j="sudo -u neo4j neo4j console";
alias startneo4jbg="sudo -u neo4j neo4j start || sudo -u neo4j neo4j status";
alias checkneo4j="sudo -u neo4j neo4j status || sudo systemctl status neo4j";

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

