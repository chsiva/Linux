# Linux Tutorial
videos-- Linuxacademy.com
Download and install oracle VirtualBox

 copy pub file to remote to config passwdless authentication
 vi /etc/ssh/sshd_config -- set passwd authentication - yes
 systemctl restart sshd
 ssh-copy-id -i id_rsa.pub root@10.94.99.82
