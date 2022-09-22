Giới thiệu:
unix là hệ điều hành đa nhiệm
có 1 hệ thống tập tin duy nhất mà các chương trình sử dụng để giao tiếp với nhau (everything is a file)
khác với windows, có ký tự ổ đĩa, mọi tệp trên hệ thống đều là tệp con của một thư mục root
linux = linus + unix
câu lệnh unix: command[-options] [arguments]

# 1. Cấu trúc thư mục của Linux	
- /root: nơi bắt đầu của tất cả các file và thư mục. Chỉ có root user mới có quyền ghi trong thư mục này. 
- /bin: (user binaries) chương trình của người dùng: thư mục này chứa các chương trình thực thi. Các chương trình linux  được sử dụng bởi tất cả người dùng được lưu ở đây. vd như: ps, ls, ping, …
- /sbin: (system binaries) cũng giống như bin nhưng các chương trình dành cho admin, dành cho công việc bảo trì hệ thống. vd như: reboot, fdisk, iptables, ...
- /etc: (editable-text-configurations) các file cấu hình: chứa các file cấu hình chương trình, đồng thời chứa các shell script dùng để khởi động hoặc tắt các chương trình khác. vd: /etc/resolv.conf (config dns system), .etc/logrotate.conf (quản lý log file)
- /dev: (device) các file thiết bị: các phân vùng ổ cứng, thiết bị ngoại vi, ổ đĩa cắm ngoài, hay bất cứ thiết bị nào gắn kèm vào hệ thống đều được lưu ở đây
- /tmp: Thư mục này chứa các file tạm thời được tạo bởi hệ thống và các người dùng. Các file lưu trong thư mục này sẽ bị xóa khi hệ thống khởi động lại.
- /proc: Thông tin về các tiến trình đang chạy sẽ được lưu trong /proc dưới dạng một hệ thống file thư mục mô phỏng. Ví dụ thư mục con /proc/{pid} chứa các thông tin về tiến trình có ID là pid (pid ~ process ID). Ngoài ra đây cũng là nơi lưu thông tin về về các tài nguyên đang sử dụng của hệ thống như: /proc/version, /proc/uptime…
- /var: (file về biến chương trình) Thông tin về các biến của hệ thống được lưu trong thư mục này. Như thông tin về log file: /var/log, các gói và cơ sở dữ liệu /var/lib...
- /usr: Chứa các thư viện, file thực thi, tài liệu hướng dẫn và mã nguồn cho chương trình chạy ở level 2 của hệ thống
- /home:  chứa file cá nhân của người dùng
- /boot: chứa kernel của HĐH - tất cả các file yêu cầu khi khởi động như initrd, vmlinux. grub được lưu tại đây. 
- /lib: Chứa cá thư viện hỗ trợ cho các file thực thi trong /bin và /sbin
- /opt: chứa các ứng dụng thêm vào từ các nhà cung cấp độc lập khác. Các ứng dụng này có thể được cài ở /opt hoặc một thư mục con của /opt
- /mnt: thư mục tạm để mount các file hệ thống
- /media: Thư mục tạm này chứa các thiết bị như CdRom /media/cdrom. floppy /media/floppy hay các phân vùng đĩa cứng /media/Data (hiểu như là ổ D:/Data trong Windows)
- /srv: (serve) Chứa dữ liệu liên quan đến các dịch vụ máy chủ như /srv/svs, chứa các dữ liệu liên quan đến CVS.
- Tên đặc biệt
  - << . >> : thư mục hiện tại
  - << .. >> : thư mục cha
  - << ~ >> : thư mục cá nhân
  - << .xxx >> : tệp ẩn ( /home/root/.bashrc)

		
# 2. Tìm hiểu về Grub. Mô tả quá trình khởi động HĐH Linux
- boot loader: chương trình chịu trách nhiệm cho việc tìm và nạp kernel của hđh
- kernel: đóng vai trò để shell có thể giao tiếp và điều khiển phần cứng
- mbr: sector đầu tiên (được đánh số 0) của thiết bị lưu trữ bộ nhớ, thường có kích thước 512 bytes
- grub (grand unified bootloader): 
  - là 1 boot loader của linux (isolinux)
  - mục đích: cho phép lựa chọn một trong các hệ điều hành trên máy tính để khởi động, sau đó    chúng sẽ nạp kernel vào bộ nhớ và chuyển quyền điều khiển máy tính cho kernel
  - 
- Quá trình khởi động:
  - power on: đầu tiên bios sẽ thực hiện quá trình POST (power-on self-test) để kiểm tra xem các thiết bị phần cứng xem có trục trặc gì không. Sau khi quá trình POST diễn ra thành công thì bios sẽ tìm kiếm và boot 1 hđh chứa trong ổ cứng (thứ tự có thể được thay đổi bởi user)

  - master boot record (mbr): sau khi xác định được thiết bị lưu trữ 
được ưu tiên thì bios đọc mbr của thiết bị đó để nạp vào 1 chương trình - có tác dụng định vị và khởi động boot loader

  - boot loader
  - kernel linux được nạp và khởi chạy: khi boot loader nạp 1 phiên bản dạng nén của linux kernel, nó ngay lập tức tự giải nén và cài đặt lên RAM - nó sẽ ở RAM cho đến khi tắt máy.
  - các script trong các INITRD (initial ram disk) được thực thi: một tập các chương trình nhỏ sẽ được thực thi khi kernel mới đc khởi chạy, các chương trình này sẽ dò xét hệ thống phần cứng xem chúng cần hỗ trợ thêm gì để có thể quản lý. Sau đấy chúng có thể nạp vào 1 số module hỗ trợ và quá trình khởi động tiếp diễn
  - các chương trình init được thực thi: khi kernel đc khởi chạy xong, nó gọi 1 chương duy nhất tên là init (có PID = 1) và là cha của tất cả các tiến trình khác. Sau đó init sẽ xem trong file /etc/inittab để thực thi các script khởi động
  - các initscript được thực thi dựa trên runlevel được chọn: thực thi các script có tên bắt đầu bằng ký tự S => khởi động các hệ thống con hoặc các deamon => về cơ bản là đã khởi động xong
  - đăng nhập với giao diện đồ họa: subsystem cuối cùng được init khởi động là X Window cung cấp giao diện đồ họa để người dùng sử dụng
  - khi đăng nhập thành công vào hệ thống: một chương trình shell sẽ được bắt đầu => tất cả các chương trình, thao tác thực hiện trong phiên làm việc sẽ được thực hiện bởi shell hoặc 1 chương trình nào đấy shell khởi động.

# 3. Kernel space, User space	
- Tiến trình là quá trình thực thi 1 program. hđh sẽ cấp 1 vùng nhớ trên ram và đưa chương trình vào đấy, sau đấy cpu sẽ bắt đầu thực thi từ hàm main.
- Bộ nhớ Ram chứa các kênh/dữ liệu dạng nhị phân của Linux kernel và các tiến trình. Ram được chia làm 2 phần:
  - kernel space: là vùng không gian chứa các lệnh dữ liệu của kernel
  - user space: là vùng không gian chứa các lệnh và dữ liệu của tiến trình

- Khi 1 tiến trình sử dụng 1 dịch vụ nào đấy của kernel, tiến trình sẽ gọi 1 system call. Lúc này cpu sẽ chuyển sang chế độ kernel mode để thực thi các lệnh của kernel. Sau khi thực hiện xong và yêu cầu, kernel gửi trả kết quả cho tiến trình và trở lại chế độ user mode.
ngoài system call, ngắt cũng là một nguyên nhân khiến cho cpu chuyển qua thực thi kernel mode.

# 4. Tìm hiểu sử dụng các câu lệnh: cd, pwd, ls, cat, tail, less, more	
- cd (change disk): thay đổi thư mục làm việc
  - cd : chuyển đến home
  - cd - : chuyển đến thư mục đã ở trước đó
  - cd .. : chuyển lên 1 cấp thư mục trên
- pwd (print working directory): in ra thư mục làm việc hiện tại.  
- ls (list): in ra danh sách các thư mục con trong thư mục làm việc hiện tại
  - ls -R:  liệt kê file bao gồm cả thư mục phụ bên trong
  - ls -a: liệt kê những file ẩn
  - ls -al: liệt kê tất cả file và thư mục vs thông tin chi tiết như phân quyền, kích thước, chủ sở hữu, ...
- cat (concatenate): xuất nội dung file lên màn hình terminal: nếu file không tồn tại nó sẽ tạo ra một file rỗng mới. Có thể xem nội dung nhiều tập tin 1 lúc
- tail : hiển thị 10 dòng cuối của file văn bản (mặc định)
  - -n*: số dòng cuối muốn xuất ra (* is a number)
- more: xuất nội dung tập tin file theo từng trang
  - Enter xuống 1 dòng
  - Space xuống 1 trang
  - Chủ yếu được sử dụng khi đọc file lớn
- less: giống như more nhưng cho phép cuộn ngược lên các trang đã đọc

# 5. Tìm hiểu sử dụng các câu lệnh: find, grep, cut, sed, vim, nano, awk	
- find: tìm filehieu
*: thay thế cho 1 chuỗi, vd: find / -name…*
tìm file ẩn: find / -type f -name “.*”
tìm file được tạo trong 1h: find / -cmin -60
tìm và xóa file có dung lượng trên 100M: find / -size +100M -exec rm -rf {} \;

- grep (global regular expression print): tìm kiếm chuỗi trong file (sẽ in ra dòng chứa chuỗi cần tìm)
tìm 1 chuỗi trong file: grep “thang” thang.txt
-i: tìm kiếm ko phân biệt chữ hoa chữ thường
-v: tìm kiếm ngược
tìm kiếm nhiều chuỗi: grep -e “thang1” -e “thang2” thang.txt

- cut: trích xuất nội dung văn bản theo cột
cut -f field_list filename

- sed (stream editor): sửa đổi văn bản của 1 tệp sử dụng regex
sed ‘s/pattern/replace_string/’ filename
sed chỉ in ra các văn bản được thay thế nên sử dụng -i hoặc chuyển hướng để lưu tập tin

- vim (vi improved): 
- nano (trình soạn thảo dòng lệnh): syntax highlight, bộ đệm, tìm kiếm và thay thế văn bản, kiểm tra chính tả, mã hóa UTF-8, ...
^: ctrl
M: alt

- awk: là 1 ngôn ngữ lập trình hỗ trợ thao tác dễ dàng đối với kiểu dữ liệu có cấu trúc và tạo ra kết quả định dạng.
chỉ nhận đầu vào là file text hoặc input có dạng chuẩn rồi xuất ra output có dạng chuẩn
syntax: awk ‘/search pattern 1/ {action} /search pattern 2/ {action}’ file
cách hoạt động: đọc file theo từng dòng, nếu khớp action thì sẽ thực hiện action
tách trường: awk '{print $2}' file.txt
phép so sánh: nếu $s1 > 200 thì in ra nội dung: awk '$1 > 200' file1.txt
cú pháp điều kiện: 
awk '{
         if($1 == "apple"){
            print $2
         }
       }' file.txt

lọc kí tự: awk '/are/' file2.txt
tính tổng:  awk '{s+=$(cột cần tính)} END {print s}' {{filename}}

 	
# 6. Regular Expressions ?
- Là một biểu thức chính quy giúp xử lý chuỗi trong file
- Thường được sử dụng với ed, sed, awk, grep

# 7. Tìm hiểu về permission của file, directory. SUID, SGID, sticky bit	
- acc người sử dụng: tên, pass, home của user, nhóm, thông tin được lưu trong /etc/passwd
- nhóm người sử dụng: một user có thể thuộc 1 hoặc nhiều nhóm nhưng cần phải xác định 1 nhóm chính
- Các nhóm người sử dụng: ds nhóm dc lưu trong /etc/group, root có khả năng tạo các nhóm bổ sung ngoài các nhóm hđh đã ngầm định. Có 3 nhóm người sử dụng:
  - u - người sở hữu: người sở hữu duy nhất của file
  - g - groupe : những người sử dụng thuộc nhóm chứa file
  - o - others: những người sử dụng khác, không phải là người sở hữu file cũng như không thuộc nhóm chứa file
- mỗi nhóm người sử dụng sẽ có 1 tập các quyền (r, w, x) xác định
- mỗi file luôn thuộc về một  và một nhóm xác định
- người tạo ra file, thư mục sẽ là người sở hữu, nhóm chứa người tạo ra file sẽ là nhóm sở hữu
  - r - đọc: cho phép hiển thị nội dung file hoặc thư mục
  - w- ghi: cho phép thay đổi nội dung file và cho phép thêm hoặc xóa các file trong một thư mục
  - x - thực thi: cho phép thực thi dưới dạng 1 chương trình, cho phép quyền chuyển đến thư mục cần truy cập

- Thay đổi quyền truy cập: 
  - chmod <mode> <file> : chmod 6711 test
  - chmod <who><operation><right> <file>
  - who: u|g|o|a (all)
  - operation: + (thêm quyền), -(bỏ quyền), = (gán mới quyền)
  - right: r|w|x|s
  - Ex: -rw-rw-r-- 1 hoang user1 150 Mar 19 19:12 test.txt => chmod o+w test => -rw-rw-rw- 1 hoang user1 150 Mar 19 19:12 test.txt

- Thay đổi người sở hữu và nhóm
  - chown [-R] <user><files>
  - chgrp [group><files>
  - sticky bit: là một quyền đặc biệt, được thiết lập trên một thư mục cấp quyền ghi cho toàn bộ nhóm. Bit này đảm bảo rằng tất cả các thành viên của nhóm có thể ghi vào thư mục, nhưng chỉ người tạo file, hay chủ sở hữu file, mới có thể xóa nó
  - syntax: sử dụng chmod với option -t
  - suid (set owner user id up on execution ): là 1 file permission tạm thời cấp quyền tạm thời cho user chạy file quyền của user tạo ra file
  - Ex: khi thay đổi password (khi thay đổi sẽ thay đổi 1 số file như /etc/passwd hay /etc/shadow - là những file đc tạo bởi root) nhưng vì pw đc set suid nên có thể thực hiện lệnh mà ko cần sudo
  - syntax: chmod u+s file.txt hoặc chmod 4750 file.txt

  - sgid: (set owner user id up on execution ): tương tự suid, nếu sgid được đặt thì chương trình sẽ sử dụng quyền của group thay vì quyền của người dùng hiện tại
  - syntax: chmod g+s file1.txt hoặc chmod 2750 file1.txt

# 8. Tìm hiểu về Linking file (symbolic, hard link)		
- inode: là 1 CTDL, lưu trữ thông tin về 1 tệp thông thường, thư mục, hay những đối tượng khác.
chứa các con trỏ trỏ đến các block lưu nội dung file.
- link: là một kết nối giữa filename và dữ liệu trên disk.
- hard links: 
  - tạo liên kết trong cùng hệ thống tệp tin với 2 inode entry tương ứng cùng trỏ đến cùng 1 nội dung vật lý.
  - tất cả các tệp phải có ít nhất 1  
  - syntax: ln [source file] [dest file]

- soft links: 
  - là một file trỏ đến 1 file khác - gọi là target. Khi được tạo, nó có thể sử dụng thay cho target file
  - không chứa bản sao dữ liệu target file, tương tự như 1 shortcut
  - syntax: ln -s [source file] [dest file]

- So sánh

    |Hard links|Soft links|
    |:---|:---|
    |Chỉ liên kết được tới file, không liên kết được tới thư mục|Có thể liên kết được tới thư mục|
    |Không tham chiếu được tới file trên ổ đĩa khác|Có thể tham chiếu tới file/thư mục khác ổ đĩa|
    |Liên kết tới một file vẫn còn ngay cả khi file đó đã được di chuyển|Liên kết không còn tham chiếu được nữa nếu file được di chuyển|
    |Được liên kết với inode tham chiếu vật lý trên ổ cứng nơi chứa file|Liên kết tham chiếu tên file/thư mục trừu tượng mà không phải địa chỉ vật lý. Chúng được cung cấp inode riêng của mình|
    |Có thể làm việc với mọi ứng dụng|Một số ứng dụng không cho phép symbolic link|

# 9. ext2, ext3, ext4 là gì? Cách format Ổ cứng, Mount, unmount, fstab?. Kiểm tra dung lượng HDD, file, thư mục
- file system là cách các tập tin được tổ chức trên ổ đĩa
- ext2, ext3, ext4 là các file system của linux
- mount là quá trình hđh làm cho các tập tin và thư mục trên thiết bị lưu trữ có thể truy cập bởi người dùng thông qua hệ thống tệp của máy tính
- Giả sử ta có 1 usb và cần format
  - dh -f: để xác định chính xác ổ, vd ta có ổ /dev/sdc1 là 1 usb 
  - không thể format khi đang mount vì vậy cần unmount khỏi hệ thống trước: sudo unmount /dev/sdc1
  - sudo mkfs.ntfs /dev/sdc1
- để mount lại usb: 
  - trước tiên tạo thư mục mới trong /mnt
  - sau đó mount bằng lệnh sudo mount /dev/sdb /mnt/sdb
  - fstab: là file kiểm soát xem những file system nào được mount
 	
# 10. Kiểm tra phiên bản HĐH, cách update HĐH.		
- cat /etc/*release
- cat /etc/issue
- cat /etc/os-release

hostnamectl
uname -r

do-release-upgrade với switch -d

# 11. Biến môi trường.	
- Là các biến chứa cấu hình file hoặc thông số các chương trình.
- Là các biến có sẵn trên toàn hệ thống và được kế thừa bởi tất cả các tiến trình và dc shell sinh ra			
 	
# 12. Tìm hiểu về Pipes (command 1 | command 2)
- Là 1 cơ chế cho phép ghép nhiều lệnh với nhau theo kiểu output của lệnh A sẽ là input cho lệnh B
- cách sử dụng: cmd1 | cmd2 | cmd3 |...
- Cách kiểm tra phần cứng của Server: Main, RAM, HDD, CPU  	
  - dmidecode | grep “System Information” -A 9 ( nhà sản xuất )
  - dmidecode | grep “Base Board” – A 10 (main board )
  - cat /proc/cpuinfo | head –n 25 (cpu)
  - cat /proc/meminfo  (ram)
  - cat /proc/scsi/scsi (hdd)


