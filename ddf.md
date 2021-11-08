# Deploy MySQL (Master-Slave) (MySQL: 5.7)

## Sơ đồ kiến trúc 
![so-do-kien-truc](/uploads/e591e31f897411f8361db9f349647ce1/so-do-kien-truc.PNG)

## Yêu cầu Server (2 node Ubuntu:18.04, MySQL 5.7)

| STT | Tên Server | IP-WAN | IP-LAN | Public-Port | 
| --- | ---------- | ------ | ------ | ----------- |
| 1 | DB-Master | 10.207.168.147 | 172.16.0.13 |  3306,9100  |
|2  | DB-Slave  | 10.207.168.148 | 172.16.0.14 |  3306,9100  |

* **Note**: MySQL đồng bộ binlog qua IP-LAN, IP-WAN chỉ mở cho phép IP của web Server và Server Monitoring kết nối đến thông qua IP-table.

## Turning hệ điều hành
* Làm theo hướng dẫn tại đây: 
[Turning-He-Dieu-Hanh](https://gitbcn.bkav.com/tunvh/khaibaoyte/-/tree/master/Turnning-HDH)

## Mount ổ cứng gắn ngoài vào để lưu trữ data MySQL 

> sudo mkfs.ext4 "tên ổ ngoài"

> sudo mkdir /u01 

> sudo mount /"tển ở cắm ngoài" /u01  

## FStab để reboot lại server không cần phải mount lại ổ 

> sudo vim /etc/fstab 

```
#add thêm dòng này vào 

/"tên ổ cắm ngoài" /u01 ext4 defaults 1 0 
```
## Cài đặt MySQL 5.7 trên cả 2 Node (Master và Slave)

B1: Add MySQL APT repository in Ubuntu 

> sudo apt-get update -y 

> sudo apt-get install wget -y 

> wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb


### Install the repository by running the command below: 

> sudo dpkg -i mysql-apt-config_0.8.12-1_all.deb

* In the prompt, chọn **Ubuntu Bionic** and click **OK**

![1](/uploads/6d278e4b41a39564e2c0fc279b88f2e2/1.PNG)

* The next prompt shows MySQL 8.0 chosen by default. Choose **the first option** and click **OK**

![2](/uploads/ef3d95125362a5832ccca2fab7a1ad60/2.PNG)

* In the next prompt, select **MySQL 5.7** server and click **OK**.

![3](/uploads/b1364b07da900a31624dcd1b2700cb5a/3.PNG)

* The next prompt selects MySQL5.7 by default. Choose **the last otpion Ok** and click **OK**.

![4](/uploads/c072e9188ec3159532a2fc78edb46c20/4.PNG)

B2: Update MySQL Repository on Ubuntu

> sudo apt-get update -y 

> sudo apt-cache policy mysql-server

B3: Install MySQL 5.7 on Ubuntu 18.04 Linux machine.

> sudo apt install -f mysql-client=5.7* mysql-community-server=5.7* mysql-server=5.7*

* Điền password tùy chọn 
![password](/uploads/3b86a7124dae8b8de26008ceb59adbce/password.PNG)

B4: Secure MySQL 5.7 Installation on Ubuntu 18.04 

> sudo mysql_secure_installation

**Note**: change password root nếu cần thiết. 

## Thay đổi thư mục chứa data MYSQL do mặc định nó lưu vào /var/lib/mysql 

> sudo mkdir -p /u01/lib/mysql

> sudo mkdir -p /u01/lib/mysql-keyring

> sudo mkdir -p /u01/lib/mysql-files

> sudo mkdir -p /u01/log/mysql

> sudo mkdir -p /u01/log/mysql/tmp 

> sudo chown -R mysql:mysql /u01/lib/mysql 

> sudo chown -R mysql:mysql /u01/log/mysql

> sudo chown -R mysql:mysql /u01/log/mysql

> sudo chmod 750 /u01/lib/mysql

> sudo chmod 750 /u01/lib/mysql-keyring

> sudo chmod 770 /u01/lib/mysql-files

> sudo vim /etc/apparmor.d/usr.sbin.mysqld

```
#include <tunables/global>

/usr/sbin/mysqld {
  #include <abstractions/base>
  #include <abstractions/nameservice>
  #include <abstractions/user-tmp>
  #include <abstractions/mysql>
  #include <abstractions/winbind>

# Allow system resource access
  /sys/devices/system/cpu/ r,
  /sys/devices/system/node/ r,
  /sys/devices/system/node/** r,
  /proc/*/status r,
  capability sys_resource,
  capability dac_override,
  capability setuid,
  capability setgid,

# Allow network access
  network tcp,

  /etc/hosts.allow r,
  /etc/hosts.deny r,

# Allow config access
  /etc/mysql/** r,

# Allow pid, socket, socket lock file access
  /var/run/mysqld/mysqld.pid rw,
  /var/run/mysqld/mysqld.sock rw,
  /var/run/mysqld/mysqld.sock.lock rw,
  /run/mysqld/mysqld.pid rw,
  /run/mysqld/mysqld.sock rw,
  /run/mysqld/mysqld.sock.lock rw,

# Allow execution of server binary
  /usr/sbin/mysqld mr,
  /usr/sbin/mysqld-debug mr,

# Allow plugin access
  /usr/lib/mysql/plugin/ r,
  /usr/lib/mysql/plugin/*.so* mr,

# Allow error msg and charset access
  /usr/share/mysql/ r,
  /usr/share/mysql/** r,

# Allow data dir access
  /u01/lib/mysql/ r,
  /u01/lib/mysql/** rwk,

# Allow data files dir access
  /u01/lib/mysql-files/ r,
  /u01/lib/mysql-files/** rwk,

# Allow keyring dir access
  /u01/lib/mysql-keyring/ r,
  /u01/lib/mysql-keyring/** rwk,

# Allow log file access
  /u01/log/mysql/ r,
  /u01/log/mysql/** rw,

  # Site-specific additions and overrides. See local/README for details.
  #include <local/usr.sbin.mysqld>
}
```

> sudo vim /etc/apparmor.d/local/usr.sbin.mysqld

```
/u01/lib/mysql/ r,
/u01/lib/mysql/** rwk,
```

> sudo systemctl restart apparmor

## Config Master-Slave MySQL. 
B1: Thay dổi file cấu hình trên master 

> sudo systemctl stop mysql

> sudo echo "" > /etc/mysql/mysql.conf.d/mysqld.cnf 

> sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf 
```
[mysqld]

user=mysql
log-bin = /u01/log/mysql/mysql-bin
server-id = 1
bind-address = 0.0.0.0
innodb_file_per_table=1
innodb_log_file_size=256M
expire_logs_days        = 1
relay_log           = /u01/log/mysql/mysql-relay-bin    # là nơi ghi lại thông tin dữ liệu bị thay đổi được lấy từ Master server.
relay_log_index     = /u01/log/mysql/mysql-relay-bin.index


socket=/var/run/mysqld/mysqld.sock
symbolic-links=0
slave-skip-errors = 1062

datadir = /u01/lib/mysql
log-error=/u01/log/mysql/error.log  #Đường dẫn tới nơi chứa log lỗi khi khởi động, dừng hoặc trong quá trình hoạt động của mysql
pid-file=/var/run/mysqld/mysqld.pid          #
[mysql_safe]
key_buffer_size              = 2048M
query_cache_limit            = 8M
query_cache_size             = 256M
query_cache_type             = 1
query_prealloc_size          = 163840
query_alloc_block_size       = 32768
table_open_cache             = 8192
sort_buffer_size             = 32M
tmp_table_size               = 512M
max_heap_table_size          = 512M

max_allowed_packet           = 64M
thread_stack                 = 256K
thread_cache_size            = 64M
max_connections              = 1024
#thread_concurrency          = 16

skip-name-resolve

back_log                = 75
max_connect_errors      = 10

innodb_buffer_pool_size = 60G
innodb_buffer_pool_instances = 60
#innodb_additional_mem_pool_size = 64M
innodb_flush_method=O_DIRECT
innodb_log_buffer_size= 8M
innodb_online_alter_log_max_size = 150G

innodb_open_files = 81920
bulk_insert_buffer_size = 16M
read_buffer_size        = 8M
read_rnd_buffer_size    = 524288
wait_timeout=30
interactive_timeout=30
concurrent_insert       = 2
low_priority_updates    = 1
slow_query_log = 1
slow_query_log_file =/u01/log/mysql/mysql-slow.log
long_query_time = 5
log_output= FILE
net_read_timeout=300
net_write_timeout=300
tmpdir = /u01/log/mysql/tmp
[xtrabackup]
datadir = /u01/lib/mysql
streamfmt=xbstream
```

> sudo systemctl restart mysql 

B2: Thay đổi cấu hình trên Slave 

> sudo systemctl stop mysql

> sudo echo "" > /etc/mysql/mysql.conf.d/mysqld.cnf 

> sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf 

```
[mysqld]

user=mysql
log-bin = /u01/log/mysql/mysql-bin
server-id = 2
bind-address = 0.0.0.0
innodb_file_per_table=1
innodb_log_file_size=256M
expire_logs_days        = 1
relay_log           = /u01/log/mysql/mysql-relay-bin    # là nơi ghi lại thông tin dữ liệu bị thay đổi được lấy từ Master server.
relay_log_index     = /u01/log/mysql/mysql-relay-bin.index
read_only = 1

socket=/var/run/mysqld/mysqld.sock
symbolic-links=0
slave-skip-errors = 1062
datadir = /u01/lib/mysql
log-error=/u01/log/mysql/error.log  #Đường dẫn tới nơi chứa log lỗi khi khởi động, dừng hoặc trong quá trình hoạt động của mysql
pid-file=/var/run/mysqld/mysqld.pid          #
[mysql_safe]
key_buffer_size              = 2048M
query_cache_limit            = 8M
query_cache_size             = 256M
query_cache_type             = 1
query_prealloc_size          = 163840
query_alloc_block_size       = 32768
table_open_cache             = 8192
sort_buffer_size             = 32M
tmp_table_size               = 512M
max_heap_table_size          = 512M

max_allowed_packet           = 64M
thread_stack                 = 256K
thread_cache_size            = 64M
max_connections              = 1024
#thread_concurrency          = 16

skip-name-resolve

back_log                = 75
max_connect_errors      = 10

innodb_buffer_pool_size = 60G
innodb_buffer_pool_instances = 60
#innodb_additional_mem_pool_size = 64M
innodb_flush_method=O_DIRECT
innodb_log_buffer_size= 8M
innodb_online_alter_log_max_size = 150G

innodb_open_files = 81920
bulk_insert_buffer_size = 16M
read_buffer_size        = 8M
read_rnd_buffer_size    = 524288
wait_timeout=30
interactive_timeout=30
concurrent_insert       = 2
low_priority_updates    = 1
slow_query_log = 1
slow_query_log_file =/u01/log/mysql/mysql-slow.log
long_query_time = 5
log_output= FILE
net_read_timeout=300
net_write_timeout=300
tmpdir = /u01/log/mysql/tmp
[xtrabackup]
datadir = /u01/lib/mysql
streamfmt=xbstream
```

> sudo systemctl restart mysql 

B3: Create User replication on Master 

> mysql -u root -p 

> create user 'replication_user'@'172.16.0.14' identified by 'password';

> grant replication slave on *.* to 'replication_user'@'172.16.0.14';

> flush privileges;

> show master status \G
 
**NOTE**: lấy tên bin-log và position để add vào node Slave 

B4:  Create replication on Slave

> mysql -u root -p 

> CHANGE MASTER TO MASTER_HOST='172.16.0.13',MASTER_USER='replication_user', MASTER_PASSWORD='password', MASTER_LOG_FILE='binlog_file_name', MASTER_LOG_POS=$pos,MASTER_CONNECT_RETRY=10;

> start slave; 

> show slave status\G 

**NOTE**: thấy Slave_IO_RUNNING và Slave_SQL_RUNNING có giá trị là YES thì đã cấu hình xong master-slave. 

## Config IPTable cho phép server monitoring và webserver có thể kết nối đến 

> sudo vim /opt/iptables

```
# Generated by iptables-save v1.8.4 on Tue Sep 14 04:40:40 2021
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

# Luật quan trọng để acceppt các kết nối trả về
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Cho phép kết nối all chính bản thân server (localhost), nên thêm các IP của Server ngoài localhost
-A INPUT -s localhost -j ACCEPT

#Cho phép từ bất kỳ đâu ssh tới server
-A INPUT -p tcp -m multiport --dports 22 -j ACCEPT

#Cho phep $IP_SLAVE, IP_MASTER, IP_WEB kết nối tới port 3306. Hoặc multi IP trong 1 dòng
#Cho phép $IP_Monitoring connect tới port 9100.

-A INPUT -s $IP_cần_thiết -p tcp -m multiport --dports 3306 -j ACCEPT 

-A INPUT -s $IP_monitor -p tcp -m multiport --dports 9100,3306-j ACCEPT  

#DROP tất cả các kết nối khác (những kết nối không match ở trên)

-A INPUT -j DROP
COMMIT
# Completed on Tue Sep 14 04:40:40 2021

```

* Add luật vào firewall (lưu ý xem lại luật xem đã cho luật ssh port 22 chưa)

    > /sbin/iptables-restore < /opt/iptables

* Cấu hình tự load file rule khi khởi động lại
    > sudo vim /etc/rc.local

    > sudo chmod +x /etc/rc.local

    ```
    #!/bin/sh -e
    /sbin/iptables-restore < /opt/iptables
    exit 0
    ```
