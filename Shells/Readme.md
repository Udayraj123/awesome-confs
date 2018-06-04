Run these commands in this directory (`cd awesome-confs/Shells/`)-

```
 sudo cp /etc/bash.bashrc /etc/bash.bashrc.bk
 
 # For safety, you can manually add contents of appendThisTo.bashrc file to bash.bashrc file as well 
 # sudo subl /etc/bash.bashrc
 # otherwise run following-
 sudo cat appendThisTo.bashrc >> /etc/bash.bashrc
 
```

If you have fish installed -

`sudo cat config.fish >> ~/.config/fish/config.fish`

Once you've updated your bashrc file, reload the terminal using exec - 
#### Bash users
exec bash
#### Fish users
exec fish

Now you'll see an error missing file:
> cat: /home/test/.myencpswd: No such file or directory
Then follow these steps:
```
##########################  For people lazy to enter passwords- ##########################
#  Step 1 of 2 : For the first time, run this command(you can change 'mysalt' to any string) -
echo your-password-here | openssl enc -aes-128-cbc -a -salt -pass pass:mysalt >> ~/.myencpswd

#  Step 2 of 2 : Remove above entry from history-
history -d $(history | tail -2 | head -1 |  awk '{print $1;}')

#Reference -https://unix.stackexchange.com/questions/291302/password-encryption-and-decryption
```

If you don't wish to store your password on your own computer or if you are scared it would be secretly sent to me :p, 
then you shall comment out the line -
```
# Comment this line if you don't want the password-typer feature:
alias s="echo $(cat ~/.myencpswd | openssl enc -d -aes-128-cbc -a -salt -pass pass:mysalt) |"
```
Also, have a look at this link: [https://askubuntu.com/questions/24006/how-do-i-reset-a-lost-administrative-password](https://askubuntu.com/questions/24006/how-do-i-reset-a-lost-administrative-password)
