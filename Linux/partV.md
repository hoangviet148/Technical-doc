# 1. Tìm hiểu về nginx
## 1.1. nginx là gì ?  
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
  
## 1.2. Tìm hiểu cấu hình HTTP load balancing và reverse proxy
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

## 1.3. Tìm hiểu và phân tích các cấu hình trong file đính kèm
1 file cấu hình nginx có bao gồm các directive và các block directive  
Nên có tệp nhật ký khác nhau cho các server block
https://drive.google.com/drive/folders/1E5JYKv6dDo1TdUQFJx2w5k7WC5Qfzpsq?usp=sharing

## 1.4. So sánh nginx, apache 
|| Nginx | Apache |
| :---: | :---: | :---: |
| Máy chủ | máy chủ web không đồng bộ hiệu suất cao và máy chủ proxy ngược | máy chủ HTTP mã nguồn mở |
| Đa luồng | Khả năng tiếp cận không đồng bộ xử lý đa luồng | có kiến trúc đa luồng nhưng khó có khả năng mở rộng |
| Cung cấp nội dung tĩnh | dựa vào quy trình bên ngoài để thực thi và xử lý nội dung nội bộ kém | cung cấp nội dung bằng phương pháp thông thường và xử lý nội bộ dựa trên máy chủ web |
| Khả năng xử lý cùng lúc | cùng lúc nhiều kết nối | chỉ một kết nối |
| Khả năng xử lý yêu cầu của client | xử lý nhiều yêu cầu của máy khách đồng thời với tài nguyên phần cứng tối thiểu | cung cấp nhiều Mô-đun đa xử lý các yêu cầu của máy khách và lưu lượng truy cập web |

## 1.5. Một số câu hỏi thường gặp
- Nginx có tốt hơn Apache: Về tốc độ, cung cấp nội dung tĩnh, số lượng kết nối đồng thời, hỗ trợ điều hành, bảo mật và tính linh hoạt thì Nginx tốt hơn nhiều so với Apache.
- Worker process là gì: Worker process là một quy trình đơn luồng, được sử dụng để điều chỉnh hiệu suất của máy chủ Nginx. Nếu Nginx đang thực hiện công việc đòi hỏi quá nhiều CPU như SSL hoặc gzipping và bạn có 2 CPU trở lên, bạn có thể đặt worker_processes bằng số CPU.

# 2. Tìm hiểu về MySQL
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



