## Cấu hình môi trường Compute Node và Storage Node


## 1. Openstack Package

- Mặc định phiên bản openstack của ubuntu 20.04 là Ussuri

## 2. NTP

- Cài đặt chrony

```
apt install -y chrony
```

- Cấu hình NTP

```
sed -i "s/server.*/server controller1 iburst/g" /etc/chrony.conf
systemctl enable chronyd.service
systemctl restart chronyd.service
```

END. 