alias install="sudo -S apt-get install";
alias update="sudo -S apt-get update";
alias autoremove="sudo -S apt-get autoremove";
alias removeapp="sudo -S apt-get remove";
alias purgeapp="sudo -S apt-get purge";

alias files="sudo -S nautilus /";

alias bashrc="sudo -S subl /etc/bash.bashrc";
alias dotbashrc="sudo -S subl $HOME/.bashrc";
alias aptconf="sudo -S subl /etc/apt/apt.conf";
alias fishconf="sudo -S subl ~/.config/fish/config.fish";

alias restart="sudo -S shutdown -r +0";
alias shutdown="sudo -S shutdown +0";
alias remount="sudo -S mount -o remount,rw";

alias gc="gcc -o a ";

cat ~/.config/fish/config.fish | awk '{if($1=="alias")printf("%s, ",$2);}';

#For some colors-
export PS1="[\[\e[32;40m\]\@\[\e[m\]\[\e[37m\]]\[\e[m\]\[\e[33;40m\] \W\[\e[m\]\[\e[35m\]>\[\e[m\]";
