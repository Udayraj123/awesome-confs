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
