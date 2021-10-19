# 1. Tổng quan
- Quản lí các máy ảo trong môi trường OpenStack, chịu trách nhiệm khởi tạo, lập lịch, ngừng hoạt động của các máy ảo theo yêu cầu.
- Nova bao gồm nhiều tiến trình trên server, mỗi tiến trình lại thực hiện một chức năng khác nhau.
- Nova cung cấp REST API để tương tác với ứng dụng client phía người dùng, trong khi các thành phần bên trong Nova tương tác với nhau thông qua RPC.
- Các API servers thực hiện các REST request, điển hình nhất là thao tác đọc, ghi vào cơ sở dữ liệu, với tùy chọn là gửi các bản tin RPC tới các dịch vụ khác của Nova. Các bản tin RPC dược thực hiện nhờ thư viện oslo.messaging - lớp trừu tượng ở phía trên của các message queue. Hầu hết các thành phần của nova có thể chạy trên nhiều server và có một trình quản lý lắng nghe các bản tin RPC. Ngoại trừ nova-compute, vì dịch vụ nova-compute được cài đặt trên các máy compute - các máy cài đặt hypervisor mà nova-compute quản lý.
- Nova cũng sử dụng một cơ sở dữ liệu trung tâm chia sẻ chung giữa các thành phần. Tuy nhiên, vì mục tiêu nâng cấp, các cơ sở dữ liệu được truy cập thông qua một lớp đối tượng dể đảm bảo các thành phần kiểm soát đã nâng cấp vẫn có thể giao tiếp với nova-compute ở phiên bản trước đó. Để thực hiện điều này, nova-compute ủy nhiệm các yêu cầu tới cơ sở dữ liệu thông qua RPC tới một trình quản lý trung tâm, chính là dịch vụ nova-conductor.
- Để Nova hoạt động cần các services sau:
  - Keystone
  - Glance
  - Neutron
<br>

# 2. Kiến trúc
<image src="https://camo.githubusercontent.com/4f482b913a66d14fb703460ea486063a79c46295fb032c8d5168b230725ec88c/687474703a2f2f692e696d6775722e636f6d2f744d4a324e574e2e706e67" width="500">

Các dịch vụ của nova phân loại bao gồm:
- API server <br>
Là trái tim của cloud framework, nơi thực hiện các lệnh và việc kiểm soát hypervisor, storage, networking, có thể lập trình được. Các API endpoints về cơ bản là các HTTP web services thực hiện xác thực, ủy quyền và các lệnh căn bản, kiểm soát các chức năng sử dụng giao diện API của Amazon, Rackspace và các mô hình liên quan khác. Điều này cho phép các API tương thích với nhiều công cụ sẵn có, tương tác với các nhà cung cấp dịch vụ cloud khác. Điều này tạo ra để ngăn chặn vấn đề phụ thuộc vào nhà cung cấp dịch vụ.

- Message queue <br>
Message Broker cung cấp hàng đợi lưu bản tin tương tác giữa các dịch vụ, các thành phần như compute nodes, networking controllers(phần mềm kiểm soát hạ tầng mạng), API endpoints, scheduler(xác định máy vật lý nào được sử dụng để cấp phát tài nguyên ảo hóa), và các thành phần tương tự.

- Compute worker <br>
Compute worker quản lý các tài nguyên tính toán của các máy ảo trên các Compute host. API sẽ chuyển tiếp các lệnh tới compute worker để hoàn thành các nhiệm vụ sau:
  - Chạy các máy ảo
  - Xóa các máy ảo
  - Khởi động lại máy ảo
  - Attach các volume
  - Detach các volume
  - Lấy console output

- Networker Controller <br>
Network Controller quản lý tài nguyên về network trên các máy chủ. API server sẽ chuyển tiếp các lệnh thông qua message queue, sau đó sẽ được xử lý bởi Network Controller. Các thao tác vận hành đặc biệt bao gồm:
  - Cấp phát các địa chỉ IP tĩnh
  - Cấu hình VLANs cho các project
  - Cấu hình mạng cho các compute nodes
<br>

# 3. Thành phần

<image src="https://www.golinuxcloud.com/wp-content/uploads/2019/01/nova-compute-architectire_1.png">

- nova-api <br>
Tiếp nhận và phản hồi các lời gọi API từ người dùng cuối. Dịch vụ này hỗ trợ OpenStack Compute API, Amazon EC2 API và một API quản trị đặc biệt cho những người dùng thực hiện các tác vụ quản trị. Nó thực hiện một số chính sách và khởi tạo hầu hết các hoạt động điều phối, chẳng hạn như tạo máy ảo.
- nova-api-metadata <br>
Tiếp nhận yêu cầu lấy metadata từ các instance. Dịch vụ này thường được sử dụng khi triển khai chế độ multi-host với nova-network.
- nova-compute <br>
Một worker daemon thực hiện tác vụ quản lý vòng đời các máy ảo như: tạo và hủy các instance thông qua các hypervisor APIs. Ví dụ:
  - XenAPI đối với XenServer/XCP
  - libvirt đối với KVM hoặc QEMU
  - VMwareAPI đối với VMware
Tiến trình xử lý của nova-compute khá phức tạp, về cơ bản thì daemon này sẽ tiếp nhận các hành động từ hàng đợi và thực hiện một chuỗi các lệnh hệ thống như vận hành máy ảo KVM và cập nhật trạng thái của máy ảo đó vào cơ sở dữ liệu.
- nova-scheduler <br>
Daemon này lấy các yêu cầu tạo máy ảo từ hàng đợi và xác định xem server compute nào sẽ được chọn để vận hành máy ảo.

  <image src="https://www.golinuxcloud.com/wp-content/uploads/2019/01/nova-compute-architectire.png" width="400">

- nova-conductor <br>
Là module trung gian tương tác giữa nova-compute và cơ sở dữ liệu. Nó hủy tất cả các truy cập trực tiếp vào cơ sở dữ liệu tạo ra bởi nova-compute nhằm mục đích bảo mật, tránh trường hợp máy ảo bị xóa mà không có chủ ý của người dùng.
- nova-cert <br>
Là một worker daemon phục vụ dịch vụ Nova Cert cho chứng chỉ X509, được sử dụng để tạo các chứng chỉ cho euca-bundle-image. Dịch vụ này chỉ cần thiết khi sử dụng EC2 API.
- nova-network <br>
Tương tự như nova-compute, tiếp nhận yêu cầu về network từ hàng đợi và điều khiển mạng, thực hiện các tác vụ như thiết lập các giao diện bridging và thay đổi các luật của IPtables.
- nova-consoleauth <br>
 Ủy quyền tokens cho người dùng mà console proxies cung cấp. Dịch vụ này phải chạy với console proxies để làm việc.
  - nova-novnproxy: cung cấp một proxy để truy cập máy ảo đang chạy thông qua kết nối VNC. Hỗ trợ các novnc client chạy trên trình duyệt.
  - nova-spicehtml5proxy: cung cấp một proxy truy cấp máy ảo đang chạy thông qua kết nối SPICE. Hỗ trợ các client chạy trên trình duyệt hỗ trợ HTML5.
- nova-client <br>
Cho phép người dùng thực hiện tác vụ quản trị hoặc các tác vụ thông thường của người dùng cuối.
- nova-queue <br>
Là một trung tâm chuyển giao bản tin giữa các daemon. Thông thường queue này cung cấp bởi một phần mềm message queue hỗ trợ giao thức AMQP: RabbitMQ, Zero MQ.
- SQL Database <br>
Lưu trữ hầu hết trạng thái ở thời điểm biên dịch và thời điểm chạy cho hạ tầng cloud:
Các loại máy ảo đang có sẵn
Các máy tính đang đưa vào sử dụng
Hệ thống mạng sẵn sàng
Các projects.
Về cơ bản, OpenStack Compute hỗ trợ bất kỳ hệ quản trị cơ sở dữ liệu nào như SQLite3 (cho việc kiểm tra và phát triển công việc), MySQL, PostgreSQL.

# 4. Nova, Libvirt và KVM
## 4.1. Khái niệm
- KVM - QEMU
  - KVM - module của hạt nhân linux đóng vai trò tăng tốc phần cứng khi sử dụng kết hợp với hypervisor QEMU, cung cấp giải pháp ảo hóa full virtualization
  - Sử dụng libvirt làm giao diện trung gian tương tác giữa QEMU và KVM
- Libvirt (Hypervisor APIs)
  - Thực thi tất cả các thao tác quản trị và tương tác với QEMU bằng việc cung cấp các API
  - Các máy ảo được định nghĩa trong libvirt thông qua một file XML, tham chiếu tới khái niệm "domain"
  - Libvirt chuyển XML thành các tùy chọn của các dòng lệnh nhằm mục đích gọi QEMU
  - Tương thích khi sử dụng với virsh (một công cụ quản quản lý tài nguyên ảo hóa giao diện dòng lệnh)

## 4.2. Tích hợp Nova với Libvirt, KVM quản lý máy ảo