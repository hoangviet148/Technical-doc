## 1. Tìm hiểu về nginx
### 1.1. nginx là gì ?  
- Là 1 open source reverse proxy server
- Thường được chọn để cân bằng tải (load balancer), HTTP cache và máy chủ web (web server)
thường được chọn để cân bằng tải, reverse proxy, http cache, …
- Sử dụng kiến trúc đơn luồng, hướng sự kiện, không đồng bộ
- Quy trình hoạt động của nginx:
  - Khi có yêu cầu mở một website, trình duyệt sẽ liên lạc với server chứa website đó.
  - Server thực hiện việc tìm kiếm file yêu cầu của website đó và gửi ngược về cho trình duyệt.
  - Nginx hoạt động theo kiến trúc Asynchronous và Event Driven. Kiến trúc này là những Threads được quản lý trong một tiến trình, mỗi tiến trình hoạt động dựa vào các thực thể nhỏ hơn – Worker Connections.
  - Worker Process sẽ nhận các truy vấn từ Worker Connections và gửi các truy vấn đó đến Process cha – Master Process
  - Master Process sẽ trả lại kết quả cho những yêu cầu đó. Một Worker Connections có khả năng xử lý được 1024 yêu cầu tương tự nhau
  - Do đó, Nginx xử lý được hàng nghìn yêu cầu mà không gặp bất cứ khó khăn gì. Nginx luôn hiệu quả hơn khi hoạt động trên môi trường tìm kiếm, thương mại điện tử và Cloud Storage.
  
### 1.2. Tìm hiểu cấu hình HTTP load balancing và reverse proxy
- Cấu hình HTTP load balancing
  - load balancer: giải quyết các vấn đề về phân phối lưu lượng truy cập đến một số máy chủ ứng dụng và cải thiện hiệu suất, khả năng mở rộng, độ tin cậy của các ứng dụng web
  - một số phương pháp cân bằng tải
    - round-robin: yêu cầu gửi đến các server được phân phối theo vòng tròn
    - least-connected: yêu cầu được gửi đến server đang có lượng kết nối ít nhất
    - ip-hash: sử dụng hàm băm để xác định (dựa trên ip của máy khách)

- Reverse proxy
  - Là một loại proxy server là một máy chủ trung gian chuyển tiếp các yêu cầu nội dung từ nhiều máy khách đến các máy chủ khác nhau trên internet
  - Được dùng để:
    - bảo mật: bảo vệ địa chỉ IP của các server
    - cân bằng tải
    - tăng tốc độ trang web: nén dữ liệu đến và đi, lưu vào cache các nội dung thường được yêu cầu

### 1.3. Tìm hiểu và phân tích các cấu hình trong file đính kèm
1 file cấu hình nginx có bao gồm các directive và các block directive  
Nên có tệp nhật ký khác nhau cho các server block
https://drive.google.com/drive/folders/1E5JYKv6dDo1TdUQFJx2w5k7WC5Qfzpsq?usp=sharing

### 1.4. So sánh nginx, apache 
|| Nginx | Apache |
| :---: | :---: | :---: |
| Máy chủ | máy chủ web không đồng bộ hiệu suất cao và máy chủ proxy ngược | máy chủ HTTP mã nguồn mở |
| Đa luồng | Khả năng tiếp cận không đồng bộ xử lý đa luồng | có kiến trúc đa luồng nhưng khó có khả năng mở rộng |
| Cung cấp nội dung tĩnh | dựa vào quy trình bên ngoài để thực thi và xử lý nội dung nội bộ kém | cung cấp nội dung bằng phương pháp thông thường và xử lý nội bộ dựa trên máy chủ web |
| Khả năng xử lý cùng lúc | cùng lúc nhiều kết nối | chỉ một kết nối |
| Khả năng xử lý yêu cầu của client | xử lý nhiều yêu cầu của máy khách đồng thời với tài nguyên phần cứng tối thiểu | cung cấp nhiều Mô-đun đa xử lý các yêu cầu của máy khách và lưu lượng truy cập web |

### 1.5. Một số câu hỏi thường gặp
- Nginx có tốt hơn Apache: Về tốc độ, cung cấp nội dung tĩnh, số lượng kết nối đồng thời, hỗ trợ điều hành, bảo mật và tính linh hoạt thì Nginx tốt hơn nhiều so với Apache.
- Worker process là gì: Worker process là một quy trình đơn luồng, được sử dụng để điều chỉnh hiệu suất của máy chủ Nginx. Nếu Nginx đang thực hiện công việc đòi hỏi quá nhiều CPU như SSL hoặc gzipping và bạn có 2 CPU trở lên, bạn có thể đặt worker_processes bằng số CPU.

## 2. Tìm hiểu về MySQL
   3.1. MySQL là gì, các khái niệm: database, tables, field, Primary key, Foreign Key.
MySQL là hệ thống quản trị cơ sở dữ liệu quan hệ mã nguồn mở
database là tập hợp dữ liệu có cùng cấu trúc
field: là thuộc tính của 1 bảng
primary key: 
là ràng buộc để định danh bản ghi trong bảng
chứa giá trị duy nhất và không được NULL
một bảng chỉ có 1 khóa chính và khóa chính có thể bao gồm nhiều trường
foreign key
là một con trỏ trỏ tới khóa chính của bảng khác
chấp nhận dữ liệu rỗng
có thể có nhiều khóa ngoại trong 1 bảng
dùng để liên kết các bảng với nhau
   3.2.Cách tạo, xóa: database, tables, field
   3.3. Cách truy vấn dữ liệu SELECT, kết hợp WHERE, LIKE, AND, OR
   3.4. Các tạo user và phân quyền cho user
CREATE USER ‘new_user’@’localhost’ IDENTIFIED BY ‘password’;
GRANT [permission type] ON [database name].[table name] TO ‘non-root’@'localhost’;


   3.5. Các cách backup database và khôi phục lại dữ liệu
Backup
mysqldump --opt -u [uname] -p [dbname] > [backupfile.sql]
Restore
mysql -u [uname] -p [dbname] < [backupfile.sql]
   3.6.Tìm hiểu về Replicate.
MySQL Master-Slave Replication using Docker | Hacker Noon
Là quá trình nhân bản từ server master sang server slave  
khi có thay đổi trên db master thì master sẽ ghi xuống log file. Slave đọc log file và thực hiện những thao tác trong file log
Nhằm bảo toàn cơ sở dữ liệu trước những sự cố ngoài ý muốn
Mục đích sử dụng
scale-solution
tạo mới và cập nhật vẫn trên server master
truy vấn ở slave server
cân bằng tải và tăng hiệu suất truy vấn
data security
analytics
long-distance data distribution
Một số mô hình replicate
master - slave: 
phù hợp với các hệ thống có nhu cầu đọc lớn hơn nhu cầu ghi
không có phương án dự phòng cho trường hợp master lỗi




master - multi slave
master - relay server 
Sử dụng thêm 1 relay slave
khi có sự thay đổi về dữ liệu, thay vì master phải đồng bộ lên tất cả slave thì master chỉ gửi bin-log đến cho relay server, công việc đồng bộ lên các slave giờ giao cho relay server
khi có sự cố xảy ra thì có thể thay thế nhiệm vụ của master ngay lập tức 
master - master
có 2 server. Server A vừa là master vừa là slave của server B. 
cả 2 máy chủ nhận cả truy vấn đọc và ghi
    3.7.Tìm hiểu về Mysql cluster.
Là cơ sở dữ liệu được thiết kế theo kiến trúc phân tán, multi-master ACID (atomicity, consistency, isolation, durability ) with no single point of failure
Được thiết kế cho việc mở rộng và tính sẵn sàng cao/ Cung cấp khả năng truy cập tại thời gian thực trong bộ nhớ với tính nhất quán giao dịch trên các phân vùng và bộ dữ liệu phân tán. Được thiết kế cho các ứng dụng quan trọng
Kiến trúc
Horizontal data partitioning (auto-sharding)
data được tự động shard (trong suốt với user)
user có thể tự custom kiểu shard
Replicate
mysql tự động tạo ra các node group dựa trên số replicate được cấu hình.
Các update được cập nhật đồng bộ
Hybrid storage
Cho phép datasets lớn hơn dung lượng của mỗi server
Shared nothing
Một node bất kỳ nào bị lỗi cũng không ảnh hưởng đến toàn hệ thống

Thành phần
Data Node
Lưu trữ các dữ liệu theo phân vùng của cả cluster
Được thiết lập ở 2 chế độ: active và passive
active: chủ động xử lý các yêu cầu
passive: nằm dự phòng, sẵn sàng thay thế cho 1 node nếu bị hỏng
service chạy trên data node có tên ndbd
SQL Node
 Kết nối các data node để thực hiện việc truy vấn và lưu trữ dữ liệu
loại node này là option, có thể truy vấn dữ liệu thông qua NDB API hoặc C++ API
nhận các câu lệnh sql query từ phần application gửi xuống, từ đó thông qua API và giao thức riêng (NDB API) gửi câu lệnh đến data node lấy dữ liệu và trả ngược về cho ứng dụng hoặc người dùng
service chạy trên sql node là mysqld
Management Node
quản lý các sql node và data node: khởi tạo node, restart node, phân chia node group, backup dữ liệu giữa các node
Lúc cluster hoạt động ổn thì Node management mang ý nghĩa đứng giám sát bên ngoài nên nếu NM có down thì cluster vẫn hoạt động bình thường
Một số khái niệm khác
Node group
Số NG = Số DN / số bản sao
Các data node trong 1 node gr sẽ lưu các dữ liệu khác nhau
Partition
Dữ liệu không được lưu toàn bộ trên 1 node nào cả mà phải được lưu thành các phân vùng nhỏ hơn
Số phân vùng = Số data node
Replica
Số bản sao cho 1 phân vùng dữ liệu, thường sẽ là 2
Ảnh hưởng trực tiếp đến số lượng node gr. Số rep các cao thì tính toàn vẹn và độ sẵn sàng càng tốt tuy nhiên sẽ cần nhiều node hơn
Note
Nếu management node down thì cluster vẫn hoạt động bình thường
Nếu có 1 node bất kỳ bị down thì cluster vẫn hoạt động bình thường (chỉ cần 1 node trong mỗi node gr up là được)
nếu số node up không đủ để hoàn thiện database thì hệ thống sẽ tự nhận thấy việc này và gửi lệnh ngắt toàn bộ data node để bảo toàn dữ liệu



## 3. Tìm hiểu và cài đặt dịch vụ Apache
## 4. Tìm hiểu về Git
## 5. Tìm hiểu và cài đặt dịch vụ ELK.
- ELK là viết tắt của elasticsearch, logstash, kibana
- Là một nhóm phần mềm mã nguồn mở, dựa trên elastic cho phép tìm kiếm, phân tích, thể hiện trực quan trên các log thu thập được ở bất kỳ định dạng nào
- elasticsearch: 
  - database để lưu trữ và tìm kiếm log
  - cung cấp khả năng tìm kiếm qua API, lưu dữ liệu theo dạng NoSQL
  - tốc độ cao
  - sử dụng chuẩn restful và json
- logstash: tiếp nhận log từ nhiều nguồn, sau đó xử lý log và ghi dữ liệu vào elasticsearch
- kibana: giao diện để quản lý, thống kê log. Đọc thông tin từ elasticsearch
- beats: gửi dữ liệu thu thập được từ log của máy đến logstash
- khi nào sử dụng:
  - Hệ thống lớn nhiều người dùng, có nhiều service phân tán, có nhiều server chạy một lúc => số lượng máy chủ lớn và không thể đọc log riêng lẻ được

## 6. Tìm hiểu và cài đặt dịch vụ Mail Zimbra.
- Là một giải pháp, hệ thống để triển khai môi trường chia sẻ và quản lý công việc bao gồm máy chủ server và máy khách website
- Một số tính năng chính
  - Email
  - Calendar
  - Task
  - Chat
  - Contact
  - Documents
  - Briefcase
  - Mô tả quá trình gửi mail từ eoffice client đến người user khác



