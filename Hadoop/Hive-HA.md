<image src="https://docs.cloudera.com/HDPDocuments/HDP2/HDP-2.5.6/bk_hadoop-high-availability/content/figures/1/figures/multiple_hs2_example.png">

- Requires: Mysql

- Cài đặt Hive
```
sudo wget https://downloads.apache.org/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz -P /opt
cd /opt
sudo tar xzf apache-hive-3.1.2-bin.tar.gz
sudo mv apache-hive-3.1.2-bin hive
sudo chown -R hadoop:root hive
```

- Configure Hive Environment Variables
```
cd
nano .bashrc
```

add thêm vào cuối
```
export HIVE_HOME=/opt/hive
export PATH=$PATH:$HIVE_HOME/bin
```

```
source ~/.bashrc
```

- Edit hive-config.sh file
```
sudo nano $HIVE_HOME/bin/hive-config.sh
export HADOOP_HOME=/home/hadoop/hadoop-3.2.2
```

- Create Hive Directories in HDFS
Create two separate directories to store data in the HDFS layer:
  - The temporary, tmp directory is going to store the intermediate results of Hive processes.
    ```
    hdfs dfs -mkdir /tmp
    hdfs dfs -chmod g+w /tmp
    hdfs dfs -ls /
    ```
  - The warehouse directory is going to store
    ```
    hdfs dfs -mkdir -p /user/hive/warehouse
    hdfs dfs -chmod g+w /user/hive/warehouse
    hdfs dfs -ls /user/hive
    ```

- Configure hive-site.xml File
```
rm $HIVE_HOME/lib/guava-19.0.jar
cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-27.0-jre.jar $HIVE_HOME/lib/
```

```
cd $HIVE_HOME/conf
cp hive-default.xml.template hive-site.xml
nano hive-site.xml
```
Thêm đoạn sau vào đầu
```
<property>
    <name>system:java.io.tmpdir</name>
    <value>/tmp</value>
  </property>
  <property>
    <name>system:user.name</name>
    <value>${user.name}</value>
  </property>
```

- Configure Mysql as metastore
  - Chỉnh sửa bind-address => 0.0.0.0
  - Login to Mysql 
  ```
  CREATE USER 'hive'@'localhost' IDENTIFIED BY 'hoang';
  CREATE USER 'hive'@'%' IDENTIFIED BY 'hoang';
  GRANT ALL ON *.*hcatalog* TO 'hive'@'localhost';
  GRANT ALL ON *.* TO 'hive'@'%';
  flush privileges;
  ```
  - Restart mysql
  - Download Mysql-connector
  ```
  sudo wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.11/mysql-connector-java-8.0.11.jar -P /opt/hive/lib
  ```
  - Chỉnh sửa file /opt/hive/conf/hive-site.xml theo như sau
  ```
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:mysql://192.168.75.133/hcatalog?createDatabaseIfNotExist=true</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>hive</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>abc251199</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>com.mysql.jdbc.Driver</value>
  </property>
  ```
- Xóa ký tự đặc biệt trong config 
```
vim /opt/hive/conf/hive-site.xml +3210
xóa &#8 
```
- Khởi tạo metastore
```
$HIVE_HOME/bin/schematool -dbType mysql -initSchema
```
- Khởi động hive
```
hive
```

- Copy cấu hình hive sang server thứ 2
```
cd /opt
scp -r hive host:/opt
```


```
Phân quyền cho user hive với database mới được tạo ra là hcatalog
```