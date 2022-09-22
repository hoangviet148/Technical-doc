

Phần IV
1. Tìm hiểu và cấu hình Iptables.
   1.1. Khái niệm
là ứng dụng tường lửa
giám sát lưu lượng ra vào server bằng các rule được cấu hình
một số ứng dụng
mở port cho các dịch vụ mạng
chặn các ip không mong muốn
   1.2. Thành phần

tables
3 loại tables: 
filter table: dùng để lọc các những gói tin, quyết định gói tin có đi có được chuyển đến địa chỉ đích hay không), gồm các chain
nat table: sửa địa chỉ gói tin gồm các chain
mangle table: chỉnh sửa QOS (TTL, MTU,...) bit trong phần TCP Header của gói tin
mỗi table có các chain
chain chứa các rule do người quản trị cấu hình
cho phép xử lý gói tin ở những giai đoạn khác nhau
INPUT: các rule thuộc chain này áp dụng cho các gói tin ngay trước khi các gói tin được vào hệ thống 
OUTPUT: lọc gói tin đi ra từ hệ thống
FORWARD: lọc gói dữ liệu đi đến các server khác kết nối trên các NIC khác của firewall
PREROUTING: rule trong chain này được thực thi ngay khi gói tin vừa đến giao diện mạng
POSTROUTING: được thực thi ngay khi gói tin vừa rời giao diện mạng

3 hành động chính với 1 gói tin
ACCEPT: cho phép kết nối
DROP: kết nối bị chặn và không có bất kỳ phản hồi nào cho server gửi đến (thường áp dụng cho ip có hành động tấn công server).
REJECT: không cho phép kết nối nhưng phản hồi lại lỗi 
đối với những gói tin không khớp rule nào thì mặc định sẽ là chấp nhận
Rule
TARGET: hành động sẽ được thực thi
PROT: là protocol, tức là các giao thức được áp dụng để thực thi rule này. Có 3 lựa chọn: all, tcp, udp
IN: chỉ ra rule áp dụng cho gói tin đi vào từ interface nào chẳng hạn như lo, eth0, eth1 hoặc any là mọi interface
OPT: options đặc biệt cho rule đó
OUT: tương tự như IN, chỉ ra rule áp dụng cho các gói tin đi ra từ interface nào
SOURCE: source ip của gói tin
DESTINATION: địa chỉ đích của gói tin

Ví dụ về các rule
ACCEPT    all    --   lo   any   anywhere   anywhere
ACCEPT    all    --   any  any   anywhere   anywhere    ctstate  RELATED,ESTABLISHED
ACCEPT    tcp    --   any  any   anywhere   anywhere    tcp      dpt:ssh
DROP      all    --   any  any   anywhere   anywhere
  1.3. Cấu hình iptables
mở port ssh


chặn ip truy cập vào port 80


2. Đọc tài liệu và tìm hiểu viết Script (6 chương đầu tài liệu đính kèm sau)
#!/bin/bash: để hệ thống hiểu rằng script sẽ được chạy bởi shell
path name expansion
Xây dựng 2 server:
một linux có folder và mysql db. Viết script để tạo backup định kỳ, thỏa mãn một số điều kiện: tồn tại, nén được, ftp thành công, có thời gian
Một FTPs server trên window  (Filezilla)

Scripts: https://github.com/hoangviet148/learn_bash/blob/main/main.sh
Kết quả:


