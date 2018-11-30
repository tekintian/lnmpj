# webmin 控制面板安装

[debian webmin官方安装手册](http://www.webmin.com/deb.html)

## debian 安装方法

1. 先安装基本依赖包

apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python apt-transport-https

2.安装webmin apt原

编辑 /etc/apt/sources.list 在文件的末尾增加

deb https://download.webmin.com/download/repository sarge contrib
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc

apt-get update
apt-get install webmin

webmin主体样式
webmin/bwtheme.wbt.gz
webmin/theme-metal.tar





