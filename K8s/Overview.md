```
Khái niệm cần tìm hiểu: 
- Kubeadm, etcd, kubectl, kubelet
- Nodes
- Pod
- ReplicationController / ReplicaSet / Deployment: quản lý pod
- ConfigMap & Secret
- Volume
- Service 
```
# **1. Khái niệm**
- Kubernetes là một dự án mã nguồn mở để quản lý các container: automating deployment, scaling, and management các ứng dụng trên container. (Tạo, sửa, xoá, xếp lịch(schedule), mở rộng (scale)...) trên nhiều máy.
- Kubernetes viết tắt là k8s
- K8s hỗ trợ các công nghệ container là docker và rkt
- Tính năng
  - Triển khai ứng dụng nhanh chóng
  - Scale ứng dụng dễ dàng
  - Liên tục đưa ra các tính năng mới
  - Tối ưu hóa việc sử dụng tài nguyên
# **2. Vấn đề giải quyết**
## 2.1. Một số mô hình phát triển phần mềm

<img src="https://d33wubrfki0l68.cloudfront.net/26a177ede4d7b032362289c6fccd448fc4a91174/eb693/images/docs/container_evolution.svg" width="500"/>

- Cách truyền thống: Các ứng dụng chạy trên máy chủ vật lý. Không có cách nào để xác định ranh giới tài nguyên cho các ứng dụng trong máy chủ vật lý và điều nào gây ra
sự cố phân bổ tài nguyên. Ví dụ nếu nhiều ứng dụng chạy trên nhiều máy chủ, có những trường hợp một ứng dụng sẽ chiếm phần lớn tài nguyên và các ứng dụng khác sẽ hoạt 
động kém đi. Giải pháp là mỗi máy chủ chạy một ứng dụng dẫn đến không tối ưu vì tài nguyên không được sử dụng đúng mức và rất tốn kém chi phí để duy trì

- Triển khai ảo hóa: 
  - Cho phép chạy nhiều máy ảo trên một CPU của một máy chủ vật lý. Ảo hóa cho phép các ứng dụng cô lập giữa các VM và cung cấp mức độ bảo mật vì 
thông tin của 1 ứng dụng không thể bị truy cập tự do bởi ứng dụng khác

  - Ảo hóa cho phép sử dụng tốt hơn các tài nguyên và khả năng mở rộng tốt hơn vì một ứng dụng có thể được thêm hoặc cập nhật dễ dàng. Mỗi VM là một máy tính chạy tất cả các thành phần bao gồm cả hệ điều hành riêng, bên trên phần cứng được ảo hóa

- Triển khai trên container
  - Các container tương tự như các VM nhưng chúng có tính cô lập để chia sẻ hệ điều hành giữa các ứng dụng. Mỗi container có filesystem, cpu, ram, process space,... Khi được tách khỏi cơ sở hạ tầng bên dưới, chúng có khả năng chuyển lên cloud hoặc các bản phân phối OS
- [Khái niệm K8s](https://kubernetes.io/vi/docs/concepts/overview/what-is-kubernetes/)

## 2.2. Tại sao cần K8s
- Sử phát triển của triển khai phần mềm sử dụng container => cần một công cụ mạnh mẽ giúp quản lý container, để chất lượng hệ thống được tốt nhất (xử lý downtime, nhân rộng, cung cấp mẫu deployment)
- Portability: tương thích rộng rãi (aws, gg, ...)
- Scability: mở rộng linh hoạt
- High Avaibility: Khả năng sẵn sàng cao. hệ thống luôn được duy trì, ít downtime
- Cộng đồng khổng lồ
- Một số tính năng của K8s
   - Điều hành container trên nhiều host
   - Tối ưu hóa phân phối tài nguyên cần thiết cho ứng dụng
   - Kiểm soát và tự động triển khai và cập nhật ứng dụng
   - Quản lý không gian lưu trữ
   - Scale ứng dụng theo yêu cầu, on-the-fly
   - Quản lý dịch vụ dựa trên khai báo tường minh, đảm bảo ứng dụng sẽ luôn chạy theo cách đã được biết trước
   - Health-check and self-deal app with autoplacement, autorestart, autoreplication and auto scaling

# 3. Các khái niệm trong k8s
## 3.1. Pod

<image src="https://images.viblo.asia/61135076-d087-4a0c-9ea6-5232fbf896bd.png">

- Pod là 1 nhóm (1 trở lên) các container chứa ứng dụng cùng chia sẽ các tài nguyên lưu trữ, địa chỉ ip...
- Pod có thể chạy theo 2 cách:
  - 1 container ứng với một Pod (nên dùng cách này)
  - 1 Pod có thể là một ứng dụng bao gồm nhiều container được kết nối chặt chẽ và cần phải chia sẽ tài nguyên giữa các container
- Pods cung cấp hai loại tài nguyên chia sẻ cho các containers: networking và storage.
- Networking: Mỗi pod sẽ được cấp 1 địa chỉ ip. Các container trong cùng 1 Pod cùng chia sẽ network namespace (địa chỉ ip và port). Các container trong cùng pod có thể giao tiếp với nhau và có thể giao tiếp với các container ở pod khác (use the shared network resources).
- Storage: Pod có thể chỉ định một shared storage volumes. Các container trong pod có thể truy cập vào volume này.

## 3.2. Replication controllers
- Replication controller đảm bảo rằng số lượng các pod replicas đã định nghĩa luôn luôn chạy đủ số lượng tại bất kì thời điểm nào.
- Thông qua Replication controller, Kubernetes sẽ quản lý vòng đời của các pod, bao gồm scaling up and down, rolling deployments, and monitoring.

## 3.3. Services
- Vì pod có tuổi thọ ngắn nên không đảm bảo về địa chỉ IP mà chúng được cung cấp.
- Service là khái niệm được thực hiện bởi : domain name, và port. Service sẽ tự động "tìm" các pod được đánh label phù hợp (trùng với label của service), rồi chuyển các connection tới đó.
- Nếu tìm được 5 pods thoả mã label, service sẽ thực hiện load-balancing: chia connection tới từng pod theo chiến lược được chọn (VD: round-robin: lần lượt vòng tròn).
- Mỗi service sẽ được gán 1 domain do người dùng lựa chọn, khi ứng dụng cần kết nối đến service, ta chỉ cần dùng domain là xong. Domain được quản lý bởi hệ thống name server SkyDNS nội bộ của k8s - một thành phần sẽ được cài khi ta cài k8s.
- Đây là nơi bạn có thể định cấu hình cân bằng tải cho nhiều pod và expose các pod đó.

## 3.4. Volumes
- Volumes thể hiện vị trí nơi mà các container có thể truy cập và lưu trữ thông tin.
- Volumes có thể là local filesystem,local storage, Ceph, Gluster, Elastic Block Storage,..
- Persistent volume (PV) là khái niệm để đưa ra một dung lượng lưu trữ THỰC TẾ 1GB, 10GB ...
- Persistent volume claim (PVC) là khái niệm ảo, đưa ra một dung lượng CẦN THIẾT, mà ứng dụng yêu cầu.
Khi 1 PV thoả mãn yêu cầu của 1 PVC thì chúng "match" nhau, rồi "bound" (buộc / kết nối) lại với nhau.

## 3.5. Namespaces

<image src="https://hocchudong.com/wp-content/uploads/2021/07/4.1-namespace.png">

- Có thể hiểu về mặt logic thì namespace giống như một folder, nhưng folder này trong k8s trải dài trên tất cả các node. Không thể tạo 2 tệp tin trùng tên trong cùng 1 folder nhưng thay vì là tập tin thì trong namespace k8s được gọi là resource 
  - Resource: được hiểu là 1 loại tài nguyên được k8s quản lý như pods, volume, service, serviceaccount, configMap, secret, ... Bản thân namespace cũng được coi là một resource 
- Namespace hoạt động như một cơ chế nhóm bên trong Kubernetes.
Các Services, pods, replication controllers, và volumes có thể dễ dàng cộng tác trong cùng một namespace.
- Namespace cung cấp một mức độ cô lập với các phần khác của cluster.
- Một ứng dụng khi triển khai trong k8s phải thuộc vào 1 namespace nào đó.
- Mặc định khi cài đặt xong 1 cụm k8s ta sẽ có 3 namespace: kube-system, default, public
- Một số lệnh khi làm việc với namespace
  - Tạo 1 namespace
    ```
    kubectl create namespace test
    ```
  - Namespace trong k8s có cách viết ngắn gọn là ns. Để kiểm tra các namespace trong hạ tầng k8s dùng lệnh:
    ```
    kubectl get ns
    ```
  - Tương tác với các resource trong namespace
    ```
    kubeclt -n kube-system get all
    ```
  - Xem resource nào thuộc k8s nằm trong phạm vị của namespace
    ```
    kubectl api-resources --namespaced=true
    ```
## 3.6. ConfigMap (cm) - Secret
- ConfigMap là giải pháp để nhét 1 file config / đặt các ENVironment var hay set các argument khi gọi câu lệnh. ConfigMap là một cục config, mà pod nào cần, thì chỉ định là nó cần - giúp dễ dàng chia sẻ file cấu hình.
- secret dùng để lưu trữ các mật khẩu, token, ... hay những gì cần giữ bí mật. Nó nằm bên trong container.

## 3.7. Labels - Anotation
- Labels: Là các cặp key-value được Kubernetes đính kèm vào pods, replication controllers,...
- Annotations: You can use Kubernetes annotations to attach arbitrary non-identifying metadata to objects. Clients such as tools and libraries can retrieve this metadata.
- Labels can be used to select objects and to find collections of objects that satisfy certain conditions. In contrast, annotations are not used to identify and select objects.

# 3.8. Resource
- Là một loại tài nguyên được k8s quản lý như namespace, pods, volume, service, ...
- 2 loại:
  - native: có sẵn khi cài k8s
  - CRD (CustomResourceDefinition): thường được sử dụng trong các ứng dụng operator
- Phân chia theo các nhóm chức năng
  
  <image src="https://hocchudong.com/wp-content/uploads/2021/08/5.2.png">

- Phân chia theo phạm vi namespace

  <image src="https://hocchudong.com/wp-content/uploads/2021/08/5.1.png">

- Xem các resource đang có trong k8s
  ```
  kubectl api-resources --namespaced=true
  ```
# 4. Thành phần

<image src="https://techvccloud.mediacdn.vn/thumb_w/650/280518386289090560/2021/3/6/63b-1615005521186826169109.png">

## 4.1. Master node
- Chịu trách nhiệm quản lý Kubernetes cluster.
- Đây là nơi mà sẽ cấu hình các nhiệm vụ sẽ thực hiện.
- Quản lý, điều hành các work node.
### 4.1.1. API Server
- API server là nơi tiếp nhận các lệnh REST được sử dụng để kiểm soát cluster.
- Nó xử lý các yêu cầu, xác nhận chúng, thực hiện các ràng buộc.
- Trạng thái kết quả phải được duy trì ở etcd.

### 4.1.2. etcd storage
- etcd: một cơ sở dữ liệu key-value có tính khả dụng cao, phân phối và nhất quán sử dụng để tìm kiếm dịch vụ.
- Nó chủ yếu được sử dụng để chia sẻ các cấu hình và khám phá dịch vụ (service discovery).
- Ví dụ về dữ liệu được lưu trữ bởi Kubernetes trong etcd là các công việc được lên kế hoạch (jobs being scheduled), tạo và triển khai pod, services, namespaces, replication information,..

### 4.1.3. Scheduler
- Đảm nhiệm chức năng là triển khai các pods, services lên các nodes.
- Scheduler nắm các thông tin liên quan đến các tài nguyên có sẵn trên các thành viên của cluster, cũng như các yêu cầu cần thiết cho dịch vụ cấu hình để chạy và do đó có thể quyết định nơi triển khai một dịch vụ cụ thể.

### 4.1.4. controller-manager 
- Sử dụng api server để có thể xem trạng thái của cluster và từ đó thực hiện các thay đổi chính xác cho trạng thái hiện tại để trở thành một trạng thái mong muốn.
- Ví dụ Replication controller có chức năng đảm bảo rằng số lượng các pod replicas đã định nghĩa luôn luôn chạy đủ số lượng tại bất kì thời điểm nào.

## 4.2. Worker node
- Là nơi mà các pod sẽ chạy.
- Chứa tất cả các dịch vụ cần thiết để quản lý kết nối mạng giữa các container, giao tiếp với master node, và gán các tài nguyên cho các container theo kế hoạch.

### 4.2.1. Docker
- Là môi trường để chạy các container.

### 4.2.2. Kubelet
- kubelet lấy cấu hình thông tin pod từ api server và đảm bảo các containers up và running.
- kubelet chịu trách nhiệm liên lạc với master node.
Nó cũng liên lạc với etcd, để có được thông tin về dịch vụ và viết chi tiết về những cái mới được tạo ra.

### 4.2.3. Kube-proxy
- Kube-proxy hoạt động như một proxy mạng và cân bằng tải cho một dịch vụ trên một work node.
- Nó liên quan đến việc định tuyến mạng cho các gói TCP và UDP.

### 4.2.4. kubectl
- Giao diện dòng lệnh để giao tiếp với API service.
- Gửi lệnh đến master node.
