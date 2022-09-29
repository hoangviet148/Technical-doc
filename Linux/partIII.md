# 1. Có bao nhiêu cách để cài đặt một phần mềm trên Linux?	
## 1.1. Install from source code
- Lợi ích
  - có thể compiled trên đa nền tảng
  - bảo mật hơn
  - newest version
- Thành phần
  - README
  - INSTALL
  - configure
  - Makefile
- Yêu cầu để cài đặt
  - compilers
  - independent libraries
  - needed header
- Các bước tiến hành
  - download source code
  - đọc INSTALL và README files
  - run ./configure script:
    - là một shell script để kiểm tra xem hệ thống có đủ yêu cầu để cài đặt gói không
- khi hệ thống thỏa mãn thì các makefile sẽ được tạo ra
  - makefile: là các file đặc biệt hướng dẫn biên dịch mã nguồn của gói sang dạng thực thi
- compile phần mềm sử dụng make cmd

## 1.2. Install from packages
- Package là source code đã được biên dịch sẵn
- Các package được lưu ở file chạy trực tiếp mà phổ biến là .deb và .rpm. 
- Chúng chứa:
  - thông tin phần mềm
  - nhà sản xuất
  - yêu cầu về hệ thống
- Một số công cụ quản lý packages trong linux: dpkg (Debian), apt (Debian), apt-get, rpm (red hat), yum, dnf, ZYpp (SUSE and OpenSUSE), Pacman(Arch)

### 1.2.1. dpkg
- chỉ thông báo các gói cần thiết cần cài đặt thêm chứ không tự động cài đặt

### 1.2.2. apt
- tự động xác định các package phụ thuộc và cài đặt nó

### 1.2.3. rpm

# 2. Lab cài đặt MySQL, Apache, PHP bằng nhiều cách khác nhau ?
# 3. Tìm hiểu chức năng  các dịch vụ cơ bản: FTP, LDAP, DNS, DHCP, SAMBA, VPN, FIREWALL
## 3.1. FTP ( file transfer protocol)
- Là 1 giao thức trên tầng ứng dụng dùng để trao đổi file giữa các máy
mô hình client-server
- Cần 2 tcp/ip connect để hoạt động
- control connection (port 21): luôn được mở
data connection (port 20): chỉ mở khi có trao đổi dữ liệu
- là một giao thức không bảo mật nếu không được mã hóa với TLS
khi cấu hình cần mở
- command port (21)
- data port (20)
- lts data port (990)
- dải port từ 35000 đến 40000 cho kết nối passive
- active mode: có lợi cho server nhưng lại thiệt cho client
- passive mode: có lợi phía client nhưng thiệt cho server

https://tel4vn.edu.vn/blog/how-to-install-ftp-server-use-vsftpd-with-ssl-tls/

## 3.2. LDAP (lightweight directory access protocol)
- là một giao thức để truy cập các dịch vụ thư mục, cụ thể là các thư mục dựa trên X.500
- mô hình client-server
- được sử dụng để quản lý việc xác thực tập trung

## 3.3. DNS (domain name system)

## 3.4. DHCP (dynamic host configuration protocol)

## 3.5. SAMBA
- là một dịch vụ của linux, chạy trên nền giao thức smb (server message block) cho phép chia sẻ file và máy in với các máy chạy window
- hoạt động ở port 445

## 3.6. VPN (virtual private network)

## 3.7. FIREWALL
- là một công cụ bảo mật mạng giám sát lưu lượng mạng đến và đi và quyết định cho phép hoặc chặn lưu lượng cụ thể dựa trên 1 bộ quy tắc xác định
- chức năng
  - quyết định dịch vụ nào bên trong được truy cập ra bên ngoài
  - quyết định dịch bên ngoài nào được truy cập vào trong
  - cân bằng tải
  - hoạt động như một proxy trung gian

# 4. Tìm hiểu cấu hình logrotate
- Là công cụ quản lý log files theo nguyên tắc xoay vòng file log
file cấu hình: /etc/logrotate.conf
- hệ thống chạy chương trình logrotate theo thời gian lịch crontab, mặc định là daily.
- cấu hình cho từng loại file log sẽ nằm trong thư mục /etc/logrotate.d
- xem trạng thái hoạt động cơ bản đối với các loại file log nào đang được logrotate tương tác: /var/lib/logrotate.status
- ý nghĩa các giá trị cấu hình logrotate 
  - log file: có thể chỉ định cụ thể 1 hoặc nhiều file log với đường dẫn tuyệt đối
  - số file log giữ lại: rotate [count] : khi đủ thì file cũ nhất sẽ bị xóa đi
  - thời gian xoay vòng: daily, weekly, .. : log sẽ được rotate với thời gian tương ứng
  - rotate file log dựa vào dung lượng file: size [value]: rotate nếu file log vượt quá dung lượng cho phép, phần này có độ ưu tiên cao hơn rotate dựa trên thời gian
  - nén file log: compress: chương trình sẽ nén tất cả các file lại sau khi được rotate. 
  - Mặc định sử dụng gzip -> đổi thì thêm tên chương trình nén muốn sử dụng: xz, zip, bzip2
  - không muốn sử dụng -> nocompress 
  - không muốn nén ngay, thay vào đó nén vào lần rotate kế tiếp: delaycompress
  - kiểm soát phân quyền file log tạo mới: create [mode] [owner] [group]
  - missingok: nếu file log không tồn tại thì tự động di chuyển tới phần cấu hình log của file log khác mà không cần phải xuất ra thông báo lỗi
  - notifempty: không rotate log nếu file log này rỗng
  - dateext: thêm giá trị hậu tố vào các file log cũ về thời gian theo cấu trúc “YYYYMMDD"
  - sharedscripts: chỉ định chương trình logrotate đợi đến khi kiểm tra hết
- các file trong block cấu hình  thì mới chạy đến nội dung trong postrotate
thực thi chương trình lệnh: thường được sử dụng để khởi động lại dịch vụ sử dụng file log


# 5. Tìm hiểu cách cấu hình crontab (cron table)
- cron là một dịch vụ giúp đặt lịch thực hiện tiến trình tự động theo 1 khung thời gian cụ thể được thiết lập trên linux
- mục đích: tự động hóa bảo trì hệ thống, giám sát dung lượng ổ đĩa, thiết lập backup.
- những task cron thực hiện gọi là cron jobs được khởi động tự động từ /etc/init.d
- crontab là 1 file chứa thời gian biểu của các cron job và được chứa trong cron spool area /var/spool/cron/crontabs
- 1 file khác mà cron đọc là /etc/crontab
- khung thời gian được sử dụng: phút – giờ – ngày trong tháng – tháng – thứ trong tuần.
- crontab -l: hiển thị file crontab
- cron -e: tạo hoặc chỉnh sửa file crontab
- cấu trúc 1 lệnh crontab: min, hour, dom, mon, dow, user,  cmd
    ``` 
    ping www.google.com tại thời điểm 14h30 ngày 8 tháng 9
    shell script đặt tại /tmp/bill.sh
    30 14 8 9 * /tmp/bill.sh
    ```
- một số annotation
  - `*` : bất kỳ giá trị nào
  - `,` : list value cách nhau bởi dấu “,”
  - `-` : range của value
  - `/` : step của value
  - `L` : ngày cuối cùng trong tháng

# 6. Tìm hiểu về lệnh netstat (network statistic)
- là một lệnh giám sát cả chiều in và out kết nối vào server, hoặc các tuyến đường route, trạng thái card mạng
- chức năng: 
  - hiển thị các kết nối chiều vào và chiều ra
  - hiển thị bảng định tuyến route
  - hiển thị thống kê thông tin giao thức mạng
- hữu dụng trong việc giải quyết các vấn đề về network như lượng connect, traffic, tốc độ, trạng thái port, ip, …
- Một số lệnh netstat:
