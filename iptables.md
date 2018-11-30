#iptables 防火墙设置教程
安装
- for debian/ubuntu
apt-get install iptables
- for centos
yum install iptables -y

Rules file 
/etc/iptables.up.rules


开放指定的端口

iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT               #允许本地回环接口(即运行本机访问本机)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT    #允许已建立的或相关连的通行
iptables -A OUTPUT -j ACCEPT         #允许所有本机向外的访问
iptables -A INPUT -p tcp --dport 22 -j ACCEPT    #允许访问22端口
iptables -A INPUT -p tcp --dport 80 -j ACCEPT    #允许访问80端口
iptables -A INPUT -p tcp --dport 443 -j ACCEPT    #允许访问443端口
iptables -A INPUT -p tcp --dport 21 -j ACCEPT    #允许[ftp](http://man.linuxde.net/ftp "ftp命令")服务的21端口
iptables -A INPUT -p tcp --dport 20 -j ACCEPT    #允许FTP服务的20端口

iptables -A INPUT -j REJECT  #禁止其他未允许的规则访问
iptables -A FORWARD -j REJECT  #禁止其他未允许的规则访问

——————————————————    error +  错误

iptables -A INPUT -j [reject](http://man.linuxde.net/reject "reject命令")       #禁止其他未允许的规则访问
iptables -A FORWARD -j REJECT     #禁止其他未允许的规则访问</pre>

语法：
iptables(选项)(参数)

选项：

-t<表>：指定要操纵的表；
-A：向规则链中添加条目；
-D：从规则链中删除条目；
-i：向规则链中插入条目；
-R：替换规则链中的条目；
-L：显示规则链中已有的条目；
-F：清楚规则链中已有的条目；
-Z：清空规则链中的数据包计算器和字节计数器；
-N：创建新的用户自定义规则链；
-P：定义规则链中的默认目标；
-h：显示帮助信息；
-p：指定要匹配的数据包协议类型；
-s：指定要匹配的数据包源[ip](http://man.linuxde.net/ip "ip命令")地址；
-j<目标>：指定要跳转的目标；
-i<网络接口>：指定数据包进入本机的网络接口；
-o<网络接口>：指定数据包要离开本机所使用的网络接口。</pre>

iptables命令选项输入顺序：

iptables -t 表名 <-A/I/D/R> 规则链名 [规则号] <-i/o 网卡名> -p 协议名 <-s 源IP/源子网> --sport 源端口 <-d 目标IP/目标子网> --dport 目标端口 -j 动作
表名包括：

raw：高级功能，如：网址过滤。
mangle：数据包修改（QOS），用于实现服务质量。
net：地址转换，用于网关路由器。
filter：包过滤，用于防火墙规则。
规则链名包括：

INPUT链：处理输入数据包。
OUTPUT链：处理输出数据包。
PORWARD链：处理转发数据包。
PREROUTING链：用于目标地址转换（DNAT）。
POSTOUTING链：用于源地址转换（SNAT）。
动作包括：

accept：接收数据包。
DROP：丢弃数据包。
REDIRECT：重定向、映射、透明代理。
SNAT：源地址转换。
DNAT：目标地址转换。
MASQUERADE：IP伪装（NAT），用于ADSL。
LOG：日志记录。
清除已有iptables规则

iptables -F
iptables -X
iptables -Z
删除已添加的iptables规则

将所有iptables以序号标记显示，执行：

iptables -L -n --line-numbers
比如要删除INPUT里序号为8的规则，执行：

iptables -D INPUT 8
保存本文件,然后把本规则加载,使之生效,注意,iptables不需要重启,加载一次规则就成了

sudo iptables-restore < /etc/iptables.test.rules    ：因为我是执行文章上面的命令直接写入的 iptable规则 所以跳过这步
因为我是执行文章上面的命令直接写入的 iptable规则 所以跳过这步
然后再查看最新的配置,应该所有的设置都生效了.

sudo iptables -L
第四步:保存生效的配置,让系统重启的时候自动加载有效配置
iptables提供了保存当前运行的规则功能

iptables-save > /etc/iptables.up.rules
注意,如果当前用户不是root,即使使用了sudo,也会提示你没有权限,无法保存,所以执行本命令,你必须使用root用户.
可以使用sudo -i快速转到root,使用完成,请及时使用su username切换到普通帐户.
为了重启服务器后,规则自动加载,我们创建如下文件:

sudo vim /etc/network/if-pre-up.d/iptables
本文章的内容如下:

#!/bin/bash
/sbin/iptables-restore < /etc/iptables.up.rules
最后,设置本文章具体可执行仅限

chmod +x /etc/network/if-pre-up.d/iptables
第五:其它

如果你想设置某ip段可以访问所有服务,你需要在iptables.test.rules文件中加入
-A INPUT -m iprange --src-range 192.168.1.1-192.168.1.199 -j ACCEPT,然后从第三步再设置一次.注意iptables.test.rules不是必须的,它只是让你的修改时,能更好的测试.

# iptables 基础
iptables命令是Linux上常用的防火墙软件，是netfilter项目的一部分。可以直接配置，也可以通过许多前端和图形界面配置。

语法
iptables(选项)(参数)
选项
-t<表>：指定要操纵的表；
-A：向规则链中添加条目；
-D：从规则链中删除条目；
-i：向规则链中插入条目；
-R：替换规则链中的条目；
-L：显示规则链中已有的条目；
-F：清楚规则链中已有的条目；
-Z：清空规则链中的数据包计算器和字节计数器；
-N：创建新的用户自定义规则链；
-P：定义规则链中的默认目标；
-h：显示帮助信息；
-p：指定要匹配的数据包协议类型；
-s：指定要匹配的数据包源ip地址；
-j<目标>：指定要跳转的目标；
-i<网络接口>：指定数据包进入本机的网络接口；
-o<网络接口>：指定数据包要离开本机所使用的网络接口。
iptables命令选项输入顺序：

iptables -t 表名 <-A/I/D/R> 规则链名 [规则号] <-i/o 网卡名> -p 协议名 <-s 源IP/源子网> --sport 源端口 <-d 目标IP/目标子网> --dport 目标端口 -j 动作
表名包括：

raw：高级功能，如：网址过滤。
mangle：数据包修改（QOS），用于实现服务质量。
net：地址转换，用于网关路由器。
filter：包过滤，用于防火墙规则。
规则链名包括：

INPUT链：处理输入数据包。
OUTPUT链：处理输出数据包。
PORWARD链：处理转发数据包。
PREROUTING链：用于目标地址转换（DNAT）。
POSTOUTING链：用于源地址转换（SNAT）。
动作包括：

accept：接收数据包。
DROP：丢弃数据包。
REDIRECT：重定向、映射、透明代理。
SNAT：源地址转换。
DNAT：目标地址转换。
MASQUERADE：IP伪装（NAT），用于ADSL。
LOG：日志记录。
实例
清除已有iptables规则

iptables -F
iptables -X
iptables -Z
开放指定的端口

iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT               #允许本地回环接口(即运行本机访问本机)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT    #允许已建立的或相关连的通行
iptables -A OUTPUT -j ACCEPT         #允许所有本机向外的访问
iptables -A INPUT -p tcp --dport 22 -j ACCEPT    #允许访问22端口
iptables -A INPUT -p tcp --dport 80 -j ACCEPT    #允许访问80端口
iptables -A INPUT -p tcp --dport 21 -j ACCEPT    #允许ftp服务的21端口
iptables -A INPUT -p tcp --dport 20 -j ACCEPT    #允许FTP服务的20端口
iptables -A INPUT -j reject       #禁止其他未允许的规则访问
iptables -A FORWARD -j REJECT     #禁止其他未允许的规则访问
屏蔽IP

iptables -I INPUT -s 123.45.6.7 -j DROP       #屏蔽单个IP的命令
iptables -I INPUT -s 123.0.0.0/8 -j DROP      #封整个段即从123.0.0.1到123.255.255.254的命令
iptables -I INPUT -s 124.45.0.0/16 -j DROP    #封IP段即从123.45.0.1到123.45.255.254的命令
iptables -I INPUT -s 123.45.6.0/24 -j DROP    #封IP段即从123.45.6.1到123.45.6.254的命令是
查看已添加的iptables规则

iptables -L -n -v
Chain INPUT (policy DROP 48106 packets, 2690K bytes)
 pkts bytes target     prot opt in     out     source               destination         
 5075  589K ACCEPT     all  --  lo     *       0.0.0.0/0            0.0.0.0/0           
 191K   90M ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:22
1499K  133M ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:80
4364K 6351M ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED
 6256  327K ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0           

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 3382K packets, 1819M bytes)
 pkts bytes target     prot opt in     out     source               destination         
 5075  589K ACCEPT     all  --  *      lo      0.0.0.0/0            0.0.0.0/0  
删除已添加的iptables规则

将所有iptables以序号标记显示，执行：

iptables -L -n --line-numbers
比如要删除INPUT里序号为8的规则，执行：

iptables -D INPUT 8