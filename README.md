Google_drive_uploader
=====================

Google Drive Uploader bash shell version

usage: 

> ./gdu.sh yourfile

This is my first github project.

Since my linux server OS is too old to install or run a new language tool, 

I decided to write an uploader in bash shell language.

This shell script will execute Netcat SSL(nssl), so you have to install it.

http://sourceforge.net/projects/nssl/

Download & Compile it with libssl.

In Ubuntu or Debian, you can enter this command to install.

> sudo apt-get install libssl-dev

If you encounter any SSL connection problems when you using nssl command tool,

you can use ncat tool to upload files instead.

In Ubuntu or Debian, you can enter this command to install ncat.

> sudo apt-get install nmap

"ncat --ssl" command can be substituted for "nssl" command.

> ncat --ssl ssl_server 443

If you have any further queries, please do not hesitate to contact me.
