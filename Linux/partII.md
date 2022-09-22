 1. Tìm hiểu Stream, Redirection
    1.1. Stream
là các dòng dữ liệu di chuyển từ điểm này đến điểm khác (process này đến process khác, file này đến file khác, device này đến device khác) sử dụng STDIO
stream input: keyboard, text data, I/O devices
có 3 chuẩn stream
stdin
stdout
stderr
redirecting là một feature cho phép thay đổi cách đọc input và cách xuất output
    1.2. Output redirection 
là quá trình cho phép ghi stdout ra một nơi khác màn hình  	
    1.3. Input redirection 
là quá trình cho phép đọc stdin từ một nơi khác không phải keyboard
    1.4. Sử dụng
“>”: xuất stdout vào file
“<”: đọc input từ file
“>>”: append stdout vào file
“<<”: đọc từng dòng cho đến khi gặp EOF, thường kết hợp với > để tạo nội dung tệp tin với dữ liệu nhập vào. VD tạo repo MongoDB trên centos 7


file descriptors:  là 1 số nguyên dương để định danh file, ở đây stdin là 0, stdout là 1, stderr là 2. (do mọi thứ trong linux đều là file)
có thể thay > bằng 1>, >> bằng 1>>
một số trường hợp ta không muốn xử lý output thì sẽ redirect đến /dev/null
Cách ghi chung stdout và stderr vào chung 1 file 
“&>”: được sử dụng ở các shell mới
./test > dev/null 2>&1 tương đương ./test > dev/null 2> dev/null
lúc này sẽ không có gì in ra màn hình
khác ./test 2>&1  > dev/null: lúc này stderr sẽ in ra màn hình do lệnh này trỏ đến output của 2 mà 2 lúc này vẫn trỏ ra màn hình


2. Tìm hiểu Linux process.     	
   2.1. Các loại tiến trình 
     2.1.1. init process
là tiến trình được thực hiện đầu tiên của hệ thống, được khởi động khi chọn hệ điều hành trong boot loader
nhiệm vụ của nó là start và stop các process, services cần thiết
không thể bị kill 
PID = 1
đây là một daemon process
có 3 kiểu triển khai init process
System V: nếu có /etc/init.d thì hệ thống hỗ trợ
Upstart: nếu có /usr/share/upstart thì hệ thống hỗ trợ
Systemd: được sử dụng từ nhiều phiên bản mới, có thêm 1 số chức năng như mount file systems, quản lý network sockets, … Nếu có /etc/init.d thì hệ thống hỗ trợ
cách để kiểm tra hệ thống đang dùng init system nào
  		
    2.1.2. parent process - child process
1 tiến trình khi được folk (duplicate 1 tiến trình) để tạo ra process mới là parent, tt được tạo ra là child
cmd để kiểm tra các tiến trình và cha của nó: ps -ef
tiến trình cha sử dụng system call wait() để xác nhận trạng thái kết thúc của tiến trình con

    2.1.3. orphan process
là trạng thái mà process cha kết thúc khi mà tiến trình con vẫn đang chạy
lúc này init process sẽ nhận process đó làm tiến trình con
cmd kiểm tra các process orphan: ps -elf | head -1; ps -elf | awk '{if ($5 == 1) {print $0}}': orphan

    2.1.4. zombie process
là trạng thái của tiến trình con khi nó kết thúc mà tiến trình cha chưa gọi wait ( đang trong trạng thái sleep chẳng hạn). Lúc này process trở thành zombies và bị giải phóng tài nguyên nhưng các thông tin cơ bản  được giữ lại (PID, trạng thái kết thúc) để trả về khi tiến trình cha gọi wait và giải phóng hoàn toàn 
chỉ bị kill của process cha bị kill để init process nhận tiến trình này làm con và gọi hàm wait để giải phóng hoàn toàn tiến trình
cmd để kiểm tra zombies process: ps -lA | grep ‘^. Z’: trạng thái Z+




    2.1.5. daemon process
là một tiến trình chạy nền, luôn trong trạng thái hoạt động và sẽ được kích hoạt bởi 1 điều kiện nào đấy”. 
thường dùng để chạy các service ở background và ko cần user interaction (httpd, mysqld, sshd, crond, …) hoặc phục vụ các process khác
cmd để kiểm tra các daemon process: ps -xj  	
2.2. Xem các tiến trình
ps: xem các tiến trình trong terminal session hiện tại
ps -A hoặc ps -e: hiển thị mọi tiến trình hoạt động trên hệ thống ở dạng chung
pa aux: hiển thị mọi tiến trình ở định dạng bsd 	
ps -X: hiển thị các tiến trình do ta sở hữu
2.3. Gửi tín hiệu đến một tiến trình: có 3 cách
dùng lệnh kill để gửi tín hiệu đến tiến trình
2 (SIGINT): interrupt from keyboard
9 (SIGKILL): kill running process
18 (SIGCONT): continue process if it stopped
19 (SIGSTOP): stop process
-l: liệt kê các tín hiệu có thể sử dụng: có 64 loại tín hiệu
killall: tắt theo tên # pkill cũng tắt theo tên nhưng chỉ cần 1 phần tên trùng nó cũng tắt
gửi tín hiệu đến một process từ một process khác
Sử dụng keyboards
Ctrl + C: SIGINT
Ctrl + Y: SIGQUIT
Ctrl + \: SIGQUIT
3. Tìm hiểu tất cả các thông số của câu lệnh "ps -aux", "top"
aux
a = show processes for all users
u = display the process's user/owner
x = also shows processes not attached to a terminal
    3.1. ps aux
            
command: câu lệnh thực thi tiến trình
user: user owning the process
pid: mã tiến trình
%cpu: thời gian cpu sử dụng / thời gian tiến trình chạy
%mem: lượng ram tiêu thụ
vsz: show virt use vsz flag
rss (resident set size): bộ nhớ tiến trình chiếm dụng trong ram
tty (TeleTYpewriter): terminal user đã đăng nhập vào
stat: mô tả trạng thái tiến trình
R: running or runnable
D: uninterruptible sleep (usually IO)
S: interruptible sleep (waiting for an event to complete)
<: high-priority
T: process đang trong quá trình dừng chạy
Z: process là 1 zombies
N: có độ ưu tiên thấp
start: thời gian bắt đầu tiến trình
time: thời gian sử dụng cpu




    3.2. top



pr: priority
ni: nice value
virt: tổng dung bộ nhớ bị tiêu thụ bởi tiến trình (hard disk and ram)
res: bộ nhớ chiếm dụng trong ram
shr: shared memory size
s: process status
time+: total cpu time used by the task in hundredths of a second


thời gian hệ thống
thời gian hoạt động: thời gian hệ thống đã chạy
số lượng user


tải trung bình (số lượng process cần cpu xử lý): được tính sau mỗi 1, 5, 15p để cung cấp cái nhìn sơ bộ về hệ thống. VD:
1s cpu sẽ xử lý được 1 process
TB thì cứ 6s mới có 1 process để xử lý
load average = 6 / 60 = 0.1
max = số core * 1.0


thống kê về các tiến trình đang chạy


bao gồm: %CPU từ tiến trình của user, system, nice time (low priority), idle time(id),  wait for io, handling hardware interruption, time handling software, cpu ảo chờ cpu thực xử lý các tiến trình


chi tiết về bộ nhớ ram, swap đang được phân phối và sử dụng
tổng lượng ram/swap hiện có
số lượng đã sử dụng: tổng - trống - cache/buff
số lượng trống
số lượng dùng làm buff/cache
shared: hiển thị ram sử dụng cho dịch vụ ramdisk

4. Cách chạy process ở background
Là các process thực hiện các công việc và không cần input từ user như là: logging, monitoring, scheduling, user notification
thêm & ở cuối command
chuyển từ foreground sang background
Ctrl Z để chuyển sang trạng thái stop
bg để chuyển process thành background process   	
5. Process Priorities là gì
Là chỉ số của tiến trình mà hđh sẽ căn cứ vào đấy để lập lịch cho tiến trình một cách phù hợp để tối ưu sử dụng tài nguyên

5.1. User space
nice value: 
là giá trị gợi ý cho kernel những gì ưu tiên mà quá trình nên có
được phép thay đổi:
Thường PR = 20 + NI và để map với priority với kernel dùng 100 + 20 + NI
nằm trong khoảng từ -20 đến 19 (default là 0)
dùng cho các normal process
realtime priority (PR)
nằm trong dải 0-99
dùng cho real time process
5.2. Kernel space
sử dụng 1 bảng process duy nhất từ 0 - 139
0 - 99 cho real time process
100 - 139 ứng với NI từ -20 đến 19


Một số cách để theo dõi priority
top
ps
5.3. Sử dụng
Thay đổi độ ưu tiên ngay khi bắt đầu tiến trình
nice [-n value] [cmd [args]]
Thay đổi độ ưu tiên khi một tiến trình đã chạy
renice [nice value] -p [process ID]
chỉ có root hoặc sudoers mới được set NI về số âm

6. Tìm hiểu về  Runlevel 
Là trạng thái init của hệ thống quyết định những dịch vụ nào, chế độ người dùng như thế nào được khởi động 
mục đích: để quản lý các dịch vụ, xử lý các lỗi hệ thống bằng cách tự động reboot hệ thống
Tồn tại trong System V init system
Là trạng thái của linux server
0: shutdown hệ thống
1: chế độ rescue mode, single user
2: multi user 
3: multi-user with networking
4: undefined (user defined)
5: multi user, có kết nối mạng, giao diện đồ họa gui
6: reboot hệ thống

Trong Systemd thì runlevels được thay thế bằng các target unit để boot vào như:
poweroff.target - 0
rescue.target - 1
multi-user.target - 3
graphical.target - 5
reboot.target - 6
Cách kiểm tra runlevel hiện tại
runlevel

who -r

systemctl get-default (với systemd)


Cách chuyển runlevel khi hệ hống đang chạy: sudo telinit 1t







                                                       HẾT

























7. Just some note
1 tiến trình sở hữu
đầu vào chuẩn (mặc định là bàn phím)
đầu ra chuẩn (mặc định là terminal)
kênh báo lỗi chuẩn
Cấu trúc bộ nhớ tiến trình 
text segment: chứa machine language instruction 
initialized data segment: chứa biến toàn cục và biến static
Uninitialized data segment: chứa các biến toàn cục và static chỉ được khai báo chứ chưa được định nghĩa.
stack segment: chứa biến cục bộ, chương trình con
heap segment: chứa biến được cấp phát động tại thời điểm runtime

ram = active + inactive (không tính swap)
khi run 1 process và tắt đi thì systems cache lại để khi process dc bật lên thì dùng luôn chứ ko phải bật lại nữa. Nên khi tắt bật process nhiều sẽ có 1 lúc inactive bị đầy và lúc này vùng inactive sẽ bị chuyển vào swap
=> swap bị dùng nhiều -> thiếu ram -> cần nâng cấp bộ nhớ cho server
Chương trình được chia thành các page có kích thước cố định, Ram cũng được chia thành các page có kích thước giống vậy. Tại 1 thời điểm chỉ 1 vài page của tiến trình cần có mặt trong page frame của ram để chạy. Các trang chưa được sử dụng của chương trình sẽ để trong swap
