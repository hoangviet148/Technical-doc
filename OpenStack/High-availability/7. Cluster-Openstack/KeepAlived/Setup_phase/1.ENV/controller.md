## Cấu hình môi trường node controlller

  
## 1. Openstack Package 
  
- Qúa trình cài đặt sử dụng tài liệu tại : https://docs.openstack.org/ussuri/install/

  
- Mặc định phiên bản openstack của ubuntu 20.04 là Ussuri


- Upgrade hệ thống
```
apt upgrade
```
  
- Cài đặt OpenstackPython Client

```
apt install -y python3-openstackclient
```


## 2. HAproxy

  
- Cài đặt HAproxy

```
apt install haproxy -y
```


- Khởi tạo file cấu hình ban đầu cho HAProxy
```
cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.orig

cat <<EOF > /etc/haproxy/haproxy.cfg

global
  chroot  /var/lib/haproxy
  daemon
  group  haproxy
  maxconn  4000
  pidfile  /var/run/haproxy.pid
  user  haproxy

defaults
  log  global
  maxconn  4000
  option  redispatch
  retries  3
  mode    http
  timeout  http-request 10s
  timeout  queue 1m
  timeout  connect 10s
  timeout  client 1m
  timeout  server 1m
  timeout  check 10s
  
listen stats 
  bind *:9000
  mode http
  stats enable
  stats uri /stats
  stats realm HAProxy\ Statistics

EOF
```


- Khởi động dịch vụ
```
systemctl start haproxy
systemctl enable haproxy
```

## 3. KeepAvlied

**Sử dụng Keepalived quản lý VirtualIP , theo dõi dịch vụ HAproxy**

- Cài đặt Keepalived
```
apt install keepalived
```

### Cấu hình riêng trên các node

- **Cấu hình trên Controller 1**
```
cp -np /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.origin
cat << EOF > /etc/keepalived/keepalived.conf
vrrp_script chk_haproxy {           # Requires keepalived-1.1.13
        script "killall -0 haproxy"     # cheaper than pidof
        interval 2                      # check every 2 seconds
        weight 2                        # add 2 points of priif OK
}

vrrp_instance public_VIP {
        interface ens32
        state MASTER
        virtual_router_id 51
        priority 100   # 100 on master, 99 on backup
        virtual_ipaddress {
            192.168.75.127/24
        }
        unicast_src_ip 192.168.75.120   # IP address of local interface
        unicast_peer {            # IP address of peer interface
        192.168.75.126
        }
        track_script {
            chk_haproxy
        }
}

vrrp_instance internal_VIP {
        interface ens160
        state MASTER
        virtual_router_id 52
        priority 100   # 100 on master, 99 on backup
        virtual_ipaddress {
            172.16.1.100/24
        }
        unicast_src_ip 172.16.1.120   # IP address of local interface
        unicast_peer {            # IP address of peer interface
        172.16.1.126
        }
        track_script {
            chk_haproxy
        }
}
EOF
```


- **Cấu hình trên Controller 2**
```
cp -np /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.origin
cat << EOF > /etc/keepalived/keepalived.conf
vrrp_script chk_haproxy {           # Requires keepalived-1.1.13
        script "killall -0 haproxy"     # cheaper than pidof
        interval 2                      # check every 2 seconds
        weight 2                        # add 2 points of prio if OK
}

vrrp_instance public_VIP {
        interface ens32
        state BACKUP
        virtual_router_id 51
        priority 99   # 100 on master, 99 on backup
        virtual_ipaddress {
            192.168.75.127/24
        }
        unicast_src_ip 192.168.75.126   # IP address of local interface
        unicast_peer {            # IP address of peer interface
        192.168.75.120
        }

        track_script {
            chk_haproxy
        }
}

vrrp_instance internal_VIP {
        interface ens160
        state BACKUP
        virtual_router_id 52
        priority 99   # 100 on master, 99 on backup
        virtual_ipaddress {
            172.16.1.100/24
        }
        unicast_src_ip 172.16.1.126   # IP address of local interface
        unicast_peer {            # IP address of peer interface
        172.16.1.120
        }
        track_script {
            chk_haproxy
        }
}
EOF
```

### Hết cấu hình


- Khởi động service
```
systemctl start keepalived
systemctl enable keepalived
```

## 4. Network Time Protocol ( NTP )  

### 4.1 Cài đặt và cấu hình NTP Server

- Cài đặt Chrony

```
apt install -y chrony
```

- Cấu hình NTP Server - Cho phép subnet 172.16.1.0/24 đồng bộ 
```
sed -i "s/server.*/server controller1 iburst/g" /etc/chrony/chrony.conf > /dev/nul
echo "allow 172.16.1.0/24" >> /etc/chrony.conf
systemctl enable chronyd.service
systemctl start chronyd.service
```

## 5. Galera MariaDB Cluster

### 5.1 Cài đặt các thành phần 
  

- Cài đặt MariaDB và Galera
```
apt install mariadb-server python3-pymysql
```

### Cấu hình riêng trên các node Controller

### 5.2 .  Cấu hình Galera trên node Controlller 1

  
- Cấu hình MarriaDB Server cho OPS

```
cat <<EOF > /etc/mysql/mariadb.conf.d/openstack.cnf
[mysqld]
log_error = /var/log/mariadb/error.log
bind-address = controller1
default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 1000
collation_server = utf8_general_ci
character_set_server = utf8
expire_logs_days = 7
log_slave_updates = 1
log_bin_trust_function_creators = 1
max_connect_errors = 1000000
wait_timeout = 28800
tmp_table_size = 32M
net_read_timeout = 20000
net_write_timeout = 20000
max_heap_table_size = 32M
query_cache_type = 0
query_cache_size = 0M
thread_cache_size = 50
thread_pool_idle_timeout = 2000
open_files_limit = 1024
table_definition_cache = 100M
innodb_flush_method = O_DIRECT
innodb_log_file_size = 300MB
innodb_flush_log_at_trx_commit = 1
innodb_buffer_pool_size = 2048M
innodb_buffer_pool_instances = 1
innodb_read_io_threads = 2
innodb_write_io_threads = 2
innodb_doublewrite = off
innodb_log_buffer_size = 128M
innodb_thread_concurrency = 2
innodb_stats_on_metadata = 0
connect_timeout = 43200
max_allowed_packet = 1024M
max_statement_time = 3600
skip_name_resolve

EOF
```

- Khởi tạo file cấu hình tại `/etc/mysql/mariadb.conf.d`
```
cat <<EOF > /etc/mysql/mariadb.conf.d/galera.cnf 
[mysqld]
bind-address=controller1
default_storage_engine=InnoDB
binlog_format=row
innodb_autoinc_lock_mode=2

# Galera cluster configuration
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so
wsrep_cluster_address="gcomm://controller1,controller2"
wsrep_cluster_name="mariadb-galera-cluster"
wsrep_sst_method=rsync

# Cluster node configuration
wsrep_node_address="172.16.1.120"
wsrep_node_name="controller1"

binlog_format=row
innodb_locks_unsafe_for_binlog=1
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
wsrep_slave_threads=2
wsrep_convert_LOCK_to_trx=0
wsrep_retry_autocommit=1
wsrep_auto_increment_control=1

EOF

```

- Tạm dừng dịch vụ
```
systemctl stop mariadb
```


### 5.2.  Cấu hình Galera trên node Controlller 2 
  
- Cấu hình MarriaDB Server cho OPS

```
cat <<EOF > /etc/mysql/mariadb.conf.d/openstack.cnf 
[mysqld]
log_error = /var/log/mariadb/error.log
bind-address = controller2
default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 1000
collation_server = utf8_general_ci
character_set_server = utf8
expire_logs_days = 7
log_slave_updates = 1
log_bin_trust_function_creators = 1
max_connect_errors = 1000000
wait_timeout = 28800
tmp_table_size = 32M
net_read_timeout = 20000
net_write_timeout = 20000
max_heap_table_size = 32M
query_cache_type = 0
query_cache_size = 0M
thread_cache_size = 50
thread_pool_idle_timeout = 2000
open_files_limit = 1024
table_definition_cache = 100M
innodb_flush_method = O_DIRECT
innodb_log_file_size = 300MB
innodb_flush_log_at_trx_commit = 1
innodb_buffer_pool_size = 2048M
innodb_buffer_pool_instances = 1
innodb_read_io_threads = 2
innodb_write_io_threads = 2
innodb_doublewrite = off
innodb_log_buffer_size = 128M
innodb_thread_concurrency = 2
innodb_stats_on_metadata = 0
connect_timeout = 43200
max_allowed_packet = 1024M
max_statement_time = 3600
skip_name_resolve


EOF
```


- Khởi tạo file cấu hình tại `/etc/mysql/mariadb.conf.d/galera.cnf `
```
cat <<EOF > /etc/my.cnf.d/galera.cnf
[mysqld]
bind-address=controller2
default_storage_engine=InnoDB
binlog_format=row
innodb_autoinc_lock_mode=2

# Galera cluster configuration
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so
wsrep_cluster_address="gcomm://controller1,controller2"
wsrep_cluster_name="mariadb-galera-cluster"
wsrep_sst_method=rsync

# Cluster node configuration
wsrep_node_address="172.16.1.126"
wsrep_node_name="controller2"

binlog_format=row
innodb_locks_unsafe_for_binlog=1
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
wsrep_slave_threads=2
wsrep_convert_LOCK_to_trx=0
wsrep_retry_autocommit=1
wsrep_auto_increment_control=1


EOF

```

 -   Khởi tạo Cluster
```
galera_new_cluster
```

- Khởi tạo Password User root ( tùy chọn )
```
mysqladmin --user=root password "123@123Aa"
```

### Hết cấu hình 

### 5.4. Khởi động dịch vụ trên các Controller

- Khởi động dịch vụ

```
systemctl start mariadb
systemctl enable mariadb
```


### 5.5. Cấu hình Cluster check trên các  Controller 

-  Clustercheck là  chương trình bash hữu ích để tạo proxy (ví dụ: HAProxy) có khả năng giám sát Galera MariaDB Cluster
-  Cấu hình Clustercheck
```
## cai dat package

apt install -y xinetd 

# Get bash program , socket and server 
wget https://raw.githubusercontent.com/nguyenhungsync/percona-clustercheck/master/clustercheck
chmod +x clustercheck
mv clustercheck /usr/bin/


## Khoi tao user check

mysql > GRANT PROCESS ON *.* TO 'clustercheckuser'@'localhost' IDENTIFIED BY 'hoang'


## Khoi tao Service

cat <<EOF>  /etc/xinetd.d/mysqlchk
# default: on
# description: mysqlchk
service mysqlchk
{
        disable = no
        flags = REUSE
        socket_type = stream
        port = 9200
        wait = no
        user = nobody
        server = /usr/bin/clustercheck
        log_on_failure += USERID
        only_from = 0.0.0.0/0
        per_source = UNLIMITED
}
EOF

# Tạo service
echo 'mysqlchk 9200/tcp # MySQL check' >> /etc/services

# Bật xinetd
systemctl restart xinetd
systemctl enable xinetd
```

## 6. RabbitMQ

### 6.1. Cài đặt RabbitMQ Server

- Cài đặt package
```
apt install -y rabbitmq-server
```

-   Khởi động Web Management Interface , xòa tài khoản guest, khởi động tài khoản mới
```
rabbitmq-plugins enable rabbitmq_management
systemctl restart rabbitmq-server
rabbitmqctl delete_user guest
rabbitmqctl add_user openstack hoang
rabbitmqctl set_user_tags openstack administrator 
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
```


- Cấu hình HA policy 
```
rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all"}'
```

### 6.2. Khởi động Cluster

- Copy Erlang cookie từ controller1 sang các node khác 
```
scp /var/lib/rabbitmq/.erlang.cookie root@controller2:/var/lib/rabbitmq/
```
- Tai controller2
```
chown -R /etc/keystone
```
```
rabbitmqctl start_app
```

- Khởi động dịch vụ trên tất cả các node  
```
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
```


- Thực hiện join vào cluster từ các node khác controller1
```
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@controller1  ## phải sử dụng hostname
rabbitmqctl start_app
```

- Kiểm tra Cluster
```
rabbitmqctl cluster_status
```

### 6.3. Cấu hình OpenStack Service sử dụng RabbitMQ HA

- Cấu hình các node
```
transport_url=rabbit://openstack:hoang@controller1:5672,openstack:hoang@controller2:5672
```

- Cấu hình thời gian thử lại kết nối tới RabbitMQ Server
```
rabbit_retry_interval=1
```

- Số lần cố gắn kết nối tới RabbitMQ trước khi đưa về trạng thái down
```
rabbit_retry_backoff=2
```

- Sử dụng HA queue 
```
rabbit_ha_queues=true
```

- Lưu lại hàng đợi khi broker restart

```
rabbit_durable_queues=true
```



## 7. Memcached

### 7.1 Cài đặt và cấu hình Memcached
```
 apt install -y memcached python3-memcached
```


- Cho phép truy cập qua địa chỉ IP Management ( địa chỉ trên của các node ) 
```
sed -i "s/-l 127.0.0.1,::1/-l 127.0.0.1,::1,$IP_management/g" /etc/memcached.conf
```

- Khởi động dịch vụ
```
systemctl enable memcached.service
systemctl start memcached.service
```


#### 7.2. Khai báo HA

- Cấu trúc khai báo  
```
memcached_servers = controller1:11211,controller2:11211
```


END.