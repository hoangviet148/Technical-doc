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
- Kubernetes là một nền tảng nguồn mở, khả chuyển, có thể mở rộng để quản lý các ứng dụng được đóng gói và các service, giúp thuận lợi trong việc cấu hình và tự động hoá việc triển khai ứng dụng.
- Kubernetes là một hệ sinh thái lớn và phát triển nhanh chóng. Các dịch vụ, sự hỗ trợ và công cụ có sẵn rộng rãi.
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

# 3. Thành phần
- Mỗi K8s cluster bao gồm một master node (control plane) và 1 hoặc nhiều worker node

    <image src="https://raw.githubusercontent.com/xuanthulabnet/learn-kubernetes/master/imgs/kubernetes001.png" width="500">

- Master node bao gồm 4 thành phần chính
  - API server: thành phần chính để giao tiếp với các thành phần khác
  - Controller manager: gồm nhiều controller riêng cụ thể cho từng resource và thực hiện các chức năng cụ thể cho từng resource trong kube như create pod, create deploy, ...
  - Scheduler: schedule ứng dụng tới node nào
  - Etcd: là một database để lưu trạng thái và resource của cluster

- Master node chỉ có nhiệm vụ control state của cluster, nó không có ứng dụng chạy trên đó, ứng dụng sẽ chạy trên các worker node. Mỗi worker node gồm 3 thành phần chính:
  - Container runtime (docker, rkt hoặc nền tảng khác): chạy container
  - Kubelet: giao tiếp với api server, sẽ cài trên mỗi node khi thêm vào cluster
  - Kubernetes Service Proxy (kube-proxy): quản lý network và trafic của các ứng dụng trong worker node

## 3.1. K8s Pod

<image src="https://d33wubrfki0l68.cloudfront.net/5cb72d407cbe2755e581b6de757e0d81760d5b86/a9df9/docs/tutorials/kubernetes-basics/public/images/module_03_nodes.svg" width="500">

- Là thành phần cơ bản nhất để deploy và chạy một ứng dụng. Pod dùng để nhóm và chạy một hoặc nhiều container lại với nhau trên cùng một worker node, những container trong cùng một pod sẽ chia sẻ tài nguyên với nhau
- Thông thường chỉ nên run một pod với một container
- Pod giống như một wrapper của container, cung cấp cho ta thêm nhiều chức năng để để quản lý và chạy container, giúp container chạy tốt hơn là chạy trực tiếp, cung cấp các tính năng như group tài nguyên, check container health và restart, chắc chắn ứng dụng trong container đã chạy thì mới gửi request, cung cấp một số life cycle để ta có thể thêm hành động vào pod khi pod chạy và k8s sẽ quản lý pod thay vì quản lý container
    
