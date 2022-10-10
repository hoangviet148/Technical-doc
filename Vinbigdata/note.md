
```
2-3 tuần onboard:

- Tìm hiểu AWS và các thành phần trong hệ thống hiện tại: EC2, EKS, VPC, ALB, NLB, RDS, S3, Atlas, Lambda, CloudWatch, ElasticCache, SQS

- Tìm hiểu các thành phần trong EKS: Vinbase services, Ingress, monitoring, logging, jaeger, harbor, cni, authen, dns, ...

- Tìm hiểu luồng CI/CD cho các môi trường hiện có: Jenkins, ArgoCD

- Tìm hiểu các công nghệ khác (đọc hiểu): ElasticSearch, Kafka, Kubeflow, Airflow, Keycloak

- Tìm hiểu các sản phẩm: Chatbot, Virtual Assistant, Callbot, Smart Speaker
```

```
Các tool cần tìm hiểu: Ansible, Terraform, Terragrunt, Kubectl, Helm, Kustomize, K8sLens, Telepresence, aws-cli (V)
```

## Rancher
- Là công cụ giúp quản lý container bằng giao diện web: xem logs, exec shell

## Octant

## Grafana

## AWS
- IAM: 
  - cho phép quản lý truy cập vào các dịch vụ và tài nguyên aws một các bảo mật
  - tạo và quản lý người dùng, nhóm người dùng
  - sử dụng các quyền để cho phép và từ chối quyền truy cập vào tài nguyên aws của họ

- regions:
  - khu vực địa lý chứa nhiều data center
  - phần lớn các dịch vụ được triển khai ở phạm vi regions => khi khởi tạo dịch vụ ở region R1 khi đổi sang R2 thì dữ liệu không được đồng bộ mà phải khởi tạo lại
  - 1 region có thể có nhiều AZ (thường là 3, tối thiểu là 2, tối đa là 6)

- avaibility zones (AZs):
  - Mỗi AZs là 1 hoặc nhiều data center rời rạc
  - Các AZ tách biệt với nhau về mặt vật lý

- ec2: 
  - cung cấp vm có khả năng mở rộng về khả năng xử lý của các thành phần phần cứng ảo hóa
  - linh hoạt trong việc lựa chọn các phân vùng lưu trữ dữ liệu ở các nền tảng khác nhau 
  - scaling: up/down or in/out
  - security: thiết lập rank ip private, security group và network acls cho control inbound/outbound, thiết lập ipsec vpn giữa dc và aws cloud
  - cost: on-demand or reserved

- vpc:
  - là dịch vụ cho phép khởi chạy các tài nguyên aws trong mạng ảo cô lập theo logic mà bạn xác định
  - lựa chọn dải ip, tạo các mạng con, cấu hình các bảng định tuyến và cổng kết nối mạng
  - thành phần: 
    - ipv4 and ipv6 block, 
    - subnet (public and private): 
      - có thể thêm 1 hoặc nhiều subnet mỗi AZ, mỗi subnet phải nằm trong 1 AZ và không thể kéo daì đến các zone khác
      - public: 1 subnet được định tuyến đến 1 internet gateway, 1 instance trong public subnet có thể giao tiếp với internet thông qua địa chỉ IPv4 (public IPv4 address hoặc Elastic IP address)
      - private: 1 subnet không được định tuyến đến internet gateway, không thể truy cập vào các instance trên một Private Subnet từ internet.
    - routes table: tập hợp các rule được sử dụng để xác định các đường đi
    - internet connectivity:
      - internet gateway: giao tiếp giữa VPC và internet
      - nat gateway: cho phép server ảo trong mạng private có thể kết nối đến internet nhưng không cho internet kết nối đến server đó 
      - nat instance: 
    - elastic ip: 1 ipv4 có thể kết nối từ internet
    - network/subnet security
      - security group: kiểm soát lưu lượng vào và ra cho instance
      - network acl: kiểm soát lưu lượng truy cập vào và ra cho subnet

- eks: quản lý k8s master nodes
  - master node are multi-AZ to provide redundancy
  - master node will scale automatically when necesary
  - secure by default: integrate with IAM 

- ALB (application loadbalancer): hoạt động ở lớp 7, chỉ hỗ trợ giao thức http/https
- NLB (network loadbalancer)
- S3 (simple storage service): dịch vụ lưu trữ đối tượng
  - dữ liệu trên S3 được lưu trữ dưới dạng bucket
  - 1 bucket là một đơn vị lưu trữ trong S3
  - chứa các đối tượng bao gồm dữ liệu và siêu dữ liệu
- SQS (simple message queue): di chuyển dữ liệu giữa các thành phần phân tán của ứng dụng 
- ElasticCache: service cung cấp dịch vụ cache data trên aws
  - redis
    - lưu được kiểu dữ liệu phức tạp hơn như: string, hash, set, ...
    - có tính persis, sau 1 tg sẽ được lưu vào file dump
    - lưu dữ liệu vào ram
    - cho phép replication
    - tốn ram hơn memcache
  - memcache:
    - lưu trữ đơn giản dạng key-value
    - không có tính persis. Một khi xóa là xóa hẳn, không backup
    - cung cấp multi node trong 1 cluster
    - lưu dữ liệu vào Ram

- Lambda: là 1 dịch vụ tính toán, có thể upload code lên và lambda sẽ giúp chạy đoạn code đó
  - 1 dịch vụ tính toán hướng sự kiện nơi mà aws lambda chạy code và trả về sự kiện, thay đổi được lưu về S3 hoặc 1 bảng của amazon dynamodb
  - dịch vụ tính toán để chạy code và sẽ trả về các http req sử dụng api gateway hoặc dùng đến aws sdks
  - use case:
    - http api: triển khai backend logic lên cloud và invoke các function khi cần thiết chỉ bằng việc gọi http 
    - xử lý dữ liêu: ứng dụng xủ lý nhiều dữ liệu được lưu trữ trong dynamodb, có thể trigger lamda function bất cứ khi nào viết, cập nhật các bảng (tạo toàn bộ quy trình xử lý dữ liệu bằng cách kết hợp các nguồn tài nguyên aws khác nhau như s3 để lưu trữ kết quả)
    - xử lý tệp tin, luồng thời gian thực
  - thành phần:
    - lambda function
    - event source
  
- CloudWatch: Là dịch vụ giám sát, tổng hợp, phân tích dữ liệu nguồn tài nguyên trên aws. Cung cấp thông tin thực tiễn một cách realtime, cho phép giám sát các vùng nhớ ứng dụng, cơ sở hạ tầng như ram, disk, ...
  - chức năng chính là lưu nhật ký: các số liệu được thể hiện qua metric
  - hành động:
    - auto scaling
    - events: define event và hành động tương ứng khi event xảy ra. vd define 1 event là A, khi event A xảy ra thì chạy 1 hàm lambda đã viết sẵn
  - analysis:
    - metric math
    - logs insights
- RDS (relational database service)
  - cho phép dễ dàng setup, scale cơ sở dữ liệu quan hệ trên aws cloud
- MongoDB Atlas

## EKS component

### Authen
- Access control - IAM: eks tận dụng IAM để thực hiện phân quyền RBAC dựa vào IAM-rol
  - Nếu cần cấp quyền cho user riêng lẻ => sử dụng aws-auth configmap để map user với k8s rbac cụ thể
  - số lượng user lớn: IAM role liên kết với user group
  - sử dụng iam role cho sa

  => các task nên được định nghĩa rõ thành baseline và chuyển hóa thành aws cloudformation tempalate

- Access control - EKS API (eks cluster endpoint)