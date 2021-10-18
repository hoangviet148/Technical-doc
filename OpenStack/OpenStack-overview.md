# 1. Khái niệm
- Là một Cloud OS kiểm soát một lượng lớn các tài nguyên như: tính toán, lưu trữ, mạng trong một datacenter. Tất cả đều được quản lý và cung cấp thông qua API với cơ chế xác thực chung
- Hỗ trợ cả public cloud và private cloud
- Cung cấp giải pháp xây dựng hạ tầng cloud computing đơn giản, có khả năng mở rộng và nhiều tính năng phong phú
- Cung cấp dashboard cho admin quyền điều khiển và cấp quyền cho người dùng sử dụng tài nguyên thông qua giao diện web

    <image src="https://images.viblo.asia/cb937627-7f61-452e-a27a-8d32f2b46d8d.png" width="500">

# 2. Thành phần

<image src="https://www.openstack.org/assets/openstack-map/openstack-map-v20210201.svg">

## 2.1. OpenStack compute
- Là module quản lý và cung cấp máy ảo
- Hỗ trợ nhiều hypervisors: KVM, QEMU, LXC, XenServer,...
- Là công cụ mạnh mẽ có thể điều khiển: networking, cpu, storage, memory; tạo, điều khiển và xóa máy ảo; security, access control. Có thể dùng cmd hoặc giao diện trên dashboard
- Không chứa các phần mềm ảo hóa mà chứa các driven tương tác, điều khiển các kỹ thuật ảo hóa

## 2.2. OpenStack glance
- Là OpenStack image service, quản lý các disk image ảo.
- Hỗ trợ Raw, Hyper-V (VHD), Virtual Box(VDI), Qemu và VMWare
- Hành động: cập nhật thêm các virtual disk, cấu hình các public và private images và điều khiển việc truy cập vào chúng và tạo, xóa chúng

## 2.3. OpenStack object storage
- Quản lý lưu trữ
- Là hệ thống lưu trữ phân tán cho quản lý tất cả các dạng của lưu trữ như: archives, user data, virtual machine image, ...
- Có nhiều lớp redundancy và sự nhân bản được thực hiện tự động, do đó khi có node bị lỗi thì cũng không làm mất dữ liệu và việc phục hồi dữ liệu là tự động

## 2.4. Identity server (keystone)
- Quản lý xác thực cho user và projects
- Chức năng chính
  - Cung cấp dịch vụ xác thực trên Cloud
  - Hỗ trợ nhiều kiểu xác thực
  - Phân quyền theo Role-base Access Control (RBAC)

## 2.5. OpenStack network
- Là thành phần quản lý network cho các máy ảo
- cung các chức năng NaaS
- Đây là hệ thống có tính chất pluggable, scable và API-driven

## 2.6. OpenStack dashboard
- Cung cấp cho admin và user giao diện đồ họa để truy cập, cung cấp và tự động tìa nguyên cloud
- Việc thiết kế có thể mở rộng để thêm các tính năng như: billing, monitoring và các công cụ giám sát khác

# 3. Ưu, nhược điểm
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
