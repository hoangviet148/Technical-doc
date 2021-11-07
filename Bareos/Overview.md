# 1. Một số cơ chế backup dữ liệu
## 1.1. Theo đối tượng sao lưu
### 1.1.1. Logical Backup
- Là việc sao lưu các đối tượng trong database (table, schema, …)
- Có thể import/export dữ liệu ở 4 mức: database, schema, table, tablespace
- Sao chép cấu trúc và dữ liệu bảng mà không phải sao chép dữ liệu thực tế. Nó sản sinh ra các tập lệnh SQL mà có thể thực thi để sản sinh những định nghĩa đối tượng cơ sở dữ liệu ban đầu và dữ liệu bảng
- Thường được dùng cho các database ít quan trọng hoặc các database test để cấu hình cho gọn nhẹ
- Ưu điểm: không phụ thuộc về cấu hình hay phiên bản. Có thể dump từng database thậm chí từng table riêng lẽ
- Nhược điểm: tốc độ chậm
- Phương thức cụ thể:
  - mysqldump
  - mydumper

### 1.1.2. Physical Backup
- Là việc sao lưu các tệp tin tạo thành database (datafile, controlfile, bin log, …)
- Ưu điểm: tốc độ bachường được sử dụng cho các database lớn, database productionkup/restore nhanh
- Nhược điểm:ác nhau
- Có thể thực h không phù hợp nếu backup và restore trên các phiên bản mysql khiện full hoặc incremental backup, hot hoặc cold backup
- recommend kết hợp với full backup và cold backup
- Phương thức cụ thể:
  - Rsync
  - percona xtrabackup

## 1.2. Theo phương pháp sao lưu
### 1.2.1. Full Backup
- Có nghĩa là backup toàn bộ dữ liệu của bạn
- Tạo một bản copy data bao gồm 1 số phần của cơ sở dữ liệu như control file, transaction files (redo logs), archive files và data files.
- recommend sử dụng với cold backup
- Note: database phải ở archive log mode để thực hiện full physical backup
Ưu điểm:
- Dễ dàng phục hồi dữ liệu. Khi cần phục hồi lại thì sẽ phục hồi lại toàn bộ dữ liệu của ngày Backup Full
- Tính an toàn cao cho dữ liệu
- Nhược điểm
  - Thời gian backup lâu. Dữ liệu càng nhiều backup càng lâu
  - Tốn dung lượng bộ nhớ.
  - Chi phí đầu tư thiết bị lớn

### 1.2.2. Differential Backup
- Là backup những gì thay đổi so với lần Full backup gần nhất
- Ưu điểm:
  - Thời gian backup nhanh hơn
  - Dung lượng backup nhỏ hơn so với Full backup. tiết kiệm bộ nhớ
  - Tốc độ phục hồi dữ liệu sẽ nhanh hơn so với Incremental backup
- Nhược điểm:
  - Khi cần khôi phục dữ liệu cần có 2 bản backup: 1 File Full Backup và 1 File Differential Backup vào thời điểm cần restore 

### 1.2.3. Incremental Backup
- Là backup những gì thay đổi so với lần full physical backup gần nhất.
- Các file khác nhau đối với mỗi databases nhưng nguyên lý chung là chỉ lưu trữ lại transaction log files được tạo ra từ lần cuối cuối backup
- Ưu điểm:
  - Thời gian backup nhanh nhất
  - Dung lượng backup bé nhất
- Nhược điểm:
  - Khi phục hồi dữ liệu phải có đủ các bản backup
  - Thời gian restore lâu hơn so với Differential Backup

## 1.3. Theo môi trường sao lưu
### 1.3.1. Online Backup
- Backup khi database đang hoạt động
- Users có thể modify database trong qt backup. Log files changes được lưu lại và sẽ được đồng bộ với database và với bản backup
- Đòi hỏi phải chạy ở chế độ archived log mode
- Các tập tin backup: datafiles, control files, archived log files, parameter file (spfile)
- Được sử dụng khi cần full backup và service không được phép down

### 1.3.2. Offline Backup
- Backup khi database không hoạt động
- Các tập tin nên backup bao gồm: datafiles, control files, archived log file, parameter file (pfile, spfile), pw files
- Users không thể modify database trong qt backup, database và backup copy luôn đồng bộ.
- Được sử dụng chỉ khi service cho phép system downtime

# 2. Bareos
## 2.1. Khái niệm
- Là một chương trình backup dữ liệu dựa trên mô hình client/server
- Là một bản fork của bacula 5.2 

## 2.2. Ưu nhược điểm của Bareos
- Ưu điểm
  - Xử lý được multi-volume backups
  - Tự động loại bỏ old data
  - Thiết kế module khiến việc scale dễ dàng hơn
  - Có bộ lập lịch được tích hợp sẵn
  - The Volume format is documented and there are simple C programs to read/write it
  - Bareos uses well-defined (IANA registered) TCP/IP ports – no rpcs, no shared memory.
  - Cài đặt và cấu hình dễ dàng hơn các tool khác
  - Cung cấp cả GUI lẫn shell

## 2.3. Các thành phần của Bareos

<image src="https://docs.bareos.org/_images/flow.png">

- Bareos director:
  - Là chương trình điều khiển trung tâm cho tất cả các daemon khác của bareos. Nhiệm vụ của nó là lập lịch và giám sát tất cả các tác vụ sao lưu, phục hồi, kiểm soát và lưu trữ. 
  - Đây là một dịch vụ chạy ngầm (daemon) trong hệ thống linux
- Bareos console
  - Là chương trình giúp user tương tác với director thông qua command line
- Bareos File daemon
  - Là một chương trình được cài đặt trên mỗi máy client để thực hiện việc sao lưu dữ liệu. Khi có yêu cầu từ phía Director, nó sẽ tìm kiếm các file đã được định sẵn cho quá trình sao lưu (backup) và gửi chúng về Bareos Storage Daemon
  - Tùy thuộc vào hệ điều hành mà máy khách sử dụng, nó sẽ lấy và cung cấp thông tin của dữ liệu khi có yêu cầu từ Director.
  - Nó cũng đảm nhận quá trình khôi phục dữ liệu trên client.
- Bareos Storage daemon
  - Đảm nhận nhiệm vụ lưu trữ dữ liệu trong hệ thống. Khi có yêu cầu từ Director, dữ liệu và các thông tin (attributes) được gửi về từ File Daemon được đưa vào phương tiện lưu trữ vật lý hoặc các volume. Trong trường hợp nhận được yêu cầu phục hồi dữ liệu (restore), nó có trách nhiệm tìm file, dữ liệu và gửi tới File Daemon.
  - Một hệ thống Bareos có thể có nhiều Storage Daemon và được quản lý bởi Director. Và được chạy ngầm (background) trên các máy chủ phục vụ việc lưu trữ dữ liệu.
- Catalog 
  - Các dịch vụ Catalog bao gồm các chương trình có nhiệm vụ lưu trữ các thông tin chỉ mục (index) của file và thông tin volume của các file đã được backup về hệ thống.
 Nó giúp chúng ta xác định vị trí và phục hồi dữ liệu một cách nhanh chóng. 
  - Nó lưu trữ thông tin của các Volume đang được sử dụng, các Job đang chạy, và các file đã được lưu trữ. 
  - Hiện tại, Bareos hỗ trợ 3 loại database là PortgreSQL, MySQL, và SQLite. Một trong số chúng phải được chọn trước khi cài đặt Bareos.

## 2.4. Các khái niệm trong Bareos
### 2.4.1. Job and Schedule
- Getting Started with Bareos — Bareos Documentation documentation
- Backup jobs bao gồm: fileset, client, schedule cho một hoặc một số levels (Full, Incrementals) hoặc thời gian sao lưu, một pool và những intruction bổ sung
Nói một cách khác: FileSet là cái ta backup, Client là user cần backup, Schedule là thời gian backup, Pools là nơi backup
- Mỗi FileSet-Client sẽ có 1 jobs và các chỉ thị như FilesSet, Pool, Schedule có thể mix, matched giữa các jobs => thay vì chỉ định cu jtheer tên của volumes thì ta chỉ định 1 Pool và bareos dựa vào đó để

### 2.4.2. Pool, Volume and Label
- Volume là một đơn vi lưu trữ, thường là tape hoặc disk là nơi Bareos lưu trữ data từ 1 hoặc nhiều backup jobs.  9

- Volume Management — Bareos Documentation documentation
- Pool là một nhóm các volume để các bản sao lưu không bị giới hạn bởi dung lượng. Bareos sẽ chọn first avaiable volume từ Pool phù hợp với storage (Dir -> Job)
- Khi một volume đầy thì bareos sẽ chuyển trạng thái từ Append thành Full và chuyển sang Pool tiếp theo. Nếu không tìm thấy appendable volume nào tồn tại trong pool thì nó sẽ reuuse lại old volume.
- Default directory để lưu trữ file backup trên disk là /var/lib/bareos/storage/<volume-name>

## 2.5. Configuration