# 1. Khái niệm
- Là một Cloud OS kiểm soát một lượng lớn các tài nguyên như: tính toán, lưu trữ, mạng trong một datacenter. Tất cả đều được quản lý và cung cấp thông qua API với cơ chế xác thực chung
- Hỗ trợ cả public cloud và private cloud
- Do NASA và Rackspace khởi xướng giới thiệu lần đầu năm 2010. Hiện tại được phát triển bởi cộng đồng.

    <image src="https://images.viblo.asia/cb937627-7f61-452e-a27a-8d32f2b46d8d.png" width="500">

# 2. Đặc điểm
- Thiết kế theo hướng module. OpenStack là một project lớn là sự kết hợp bởi nhiều project thành phần: nova, swift, neutron, glance,...
- Hoạt động theo hướng mở: công khai lộ trình phát triển, công khai mã nguồn, thiết kế, cộng đồng phát triển là cộng đồng mã nguồn mở, etc.
- Chu kì 6 tháng phát hành phiên bản mới theo thứ tự bảng chữ cái: A, B, C...(Austin, Bexar, Cactus, etc.). Hiện tại OpenStack đã phát hành phiên bản thứ 13 - Mitaka.
- Phần lớn mã nguồn của OpenStack là python

# 3. Kiến trúc
- Kiến trúc mức khái niệm

<image src="https://docs.openstack.org/install-guide/_images/openstack_kilo_conceptual_arch.png">

- Kiến trúc mức logic

<image src="https://docs.openstack.org/install-guide/_images/openstack-arch-kilo-logical-v1.png">

# 4. Thành phần

<image src="https://www.openstack.org/assets/openstack-map/openstack-map-v20210201.svg">

6 core project của OpenStack bao gồm:
- **NOVA** - Compute service 
  - Quản lí các máy ảo trong môi trường OpenStack, chịu trách nhiệm khởi tạo, lập lịch, ngừng hoạt động của các máy ảo theo yêu cầu.
  - Starting, resizing, stopping và querying máy ảo
  - Gán và remove public IP
  - Attach và detach block storage
  - Show instance consoles (VNC)
  - Snapshot running instances
  - Nova hỗ trợ nhiều hypervisor: KVM, VMware, Xen, Docker, etc.

- **GLANCE** - Image service <br>
  Lưu trữ và truy xuất các disk images của các máy ảo của user và các cloud service khác. Openstack compute sẽ sử dụng chúng trong suốt quá trình dự phòng instances
  - Người quản trị tạo sẵn template để user có thể tạo máy ảo nhanh chóng
  - Người dùng có thể tạo máy ảo từ ổ đĩa ảo có sẵn. Glance chuyển images tới Nova để vận hành instance
  - Snapshot từ các instance đang chạy có thể được lưu trữ, vì vậy máy ảo đó có thể được back up.

- **SWIFT** - Object storage service <br>
  Cung cấp giải pháp lưu trữ và thu thập quy mô lớn dữ liệu phi cấu trúc thông qua RESTful API. Không giống như máy chủ tập tin truyền thống, giải pháp lưu trữ với Swift hoàn toàn là phân tán, lưu trữ nhiều bản sao của từng đối tượng để đạt được tính sẵn sàng cao cũng như khả năng mở rộng. Cụ thể hơn, Swift cung cấp các một số chức năng như:
  - Lưu trữ và thu thập các đối tượng (các files)
  - Thiết lập và chỉnh sửa metadata trên đối tượng(tags)
  - Đọc, ghi các đối tượng thông qua HTTP
  - etc.

- **KEYSTONE** - Identity server
  - Quản lý xác thực cho user và projects
  - Chức năng chính
  - Cung cấp dịch vụ xác thực trên Cloud
  - Hỗ trợ nhiều kiểu xác thực
  - Phân quyền theo Role-base Access Control (RBAC)

- **NEUTRON** - Network service
  - Các phiên bản trước Grizzly tên là Quantum, sau đổi tên thành Neutron
  - Cung cấp kết nối mạng như một dịch vụ (Network-Connectivity-as-a-Service) cho các dịch vụ khác của OpenStack, thay thế cho nova-network.
  - Cung cấp API cho người dùng để họ tạo các network của riêng mình và attach vào server interfaces.
  - Kiến trúc pluggable hỗ trợ các công nghệ khác nhau của các nhà cung cấp networking phổ biến.
  - Ngoài ra nó cũng cung cấp thêm các dịch vụ mạng khác như: FWaaS (Firewall as a service), LBaaS (Load balancing as a servie), VPNaaS (VPN as a service),...

- **CINDER** - Block storage service
  - Cung cấp các khối lưu trữ bền vững (volume) để chạy các máy ảo (instances).
  - Kiến trúc pluggable driver cho phép kết nối với công nghệ Storage của các hãng khác.
  - Có thể attach và detach một volume từ máy ảo này gắn sang máy ảo khác, khởi tạo instance mới
  - Có thể sao lưu, mở rộng các volume

- **HORIZON** - Dashboard service <br>
  Cung cấp giao diện nền web cho người dùng cuối và người quản trị cloud để tương tác với các dịch vụ khác của OpenStack, ví dụ như vận hành các instance, cấp phát địa chỉ IP và kiểm soát cấu hình truy cập các dịch vụ. HORIZON viết dựa trên python django framework. Một số thông tin giao diện người dùng:
  - Thông tin về quota và cách sử dụng
  - Volume Management: điều khiển khởi tạo, hủy kết nối tới các block storage
  - Images and Snapshots: up load và điều khiển các virtual images, các virtual images được sử dụng để back up hoặc boot một instance mới
  - Addition:
    - Flavors: định nghĩa các dịch vụ catalog yêu cầu về CPU, RAM và BOOT disk storage
    - Project: cung cấp các group logic của các user
    - User: quản trị các user
    - System Info: Hiển thị các dịch vụ đang chạy trên cloud

- **CEILOMETER** - Telemetry Service
  - Giám sát và đo đạc các thông số của OpenStack, thống kê tài nguyên của người sử dụng cloud phục vụ mục đích billing, benmarking, thống kê và mở rộng hệ thống
  - Đáp ứng tính năng "Pay as you go" của Cloud Computing

- **HEAT** - Orchestration Service
  - Triển khai các ứng dụng dựa trên các template dựng sẵn
  - Template sẽ mô tả cấu hình các thành phần compute, storagevaf networking để đáp ứng yêu cầu của ứng dụng.
  - Kết hợp với Ceilometer để có thể tự co dãn tài nguyên.
  - Tương thích với AWS Cloud Formation APIs

- Một số các dịch vụ cài đặt trong hệ thống OpenStack (không phải project nhưng là thành phần cần thiết của hệ thống): MySQL (MariaDB) lưu trữ dữ liệu về hoạt động của các Project, trạng thái của các instance, hệ thống network, images, etc. ; Rabbit MQ - Message Broker sử dụng để lưu trữ, trao đổi các bản tin giữa các tiến trình trong hệ thống dùng giao thức AMQP (Advanced Message Queuing Protocol); etc.

# 5. Ưu, nhược điểm
- Ưu điểm
  - Tiết kiệm chi phí
  - Hiệu suất cao
  - Nền tảng mở
  - Mềm dẻo trong tương tác
  - Khả năng phát triển, mở rộng cao
- Nhược điểm:
  - Độ ổn định chưa cao
  - Hỗ trợ đa ngôn ngữ chưa tốt
  - Chỉ có hỗ trợ kĩ thuật qua chat và mail

`
LVM: ảo hóa disk
Sas -> tích hợp cinder để tạo ra máy ảo
thuật toán rage
bare metal: quản lý bằng cloud nhưng lai vật lý
container dựa vào vm để phát triển và ngược lại: ko phủ định nhau

self service network: layer2(bridging/switching) VLAN
provider network: (layer3-routing) VLAN, VXLAN
CVE + openstack => 

open tracing: jaeger, zipkin

đồ án tốt nghiệp
tìm hiểu SDS
k8s inside openstack
mô hình multiside openstack
`