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
  - Placement
<br>

# 2. Kiến trúc
<image src="https://camo.githubusercontent.com/4f482b913a66d14fb703460ea486063a79c46295fb032c8d5168b230725ec88c/687474703a2f2f692e696d6775722e636f6d2f744d4a324e574e2e706e67" width="500">

Các dịch vụ của nova phân loại bao gồm:
- API server
- Message queue
- Compute worker
- Networker Controller
<br>

# 3. Thành phần
- nova-api
- nova-api-metadata
- nova-compute
- nova-scheduler
- nova-conductor
- nova-cert
- nova-network
- nova-consoleauth 
- nova-novnproxy
- nova-spicehtml5proxy
- nova-xvvpnproxy
- nova-client
- nova-queue
- SQL Database

# 4. Nova, Libvirt và KVM