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
- Một số tính năng của K8s
   - Service discovery và cân bằng tải: dẫn request của các ứng dụng đến đúng container
   - Điều phối bộ nhớ
   - Tự động rollouts và rollbacks
   - Đóng gói tự động
   - Tự phục hồi 
   - Quản lý cấu hình và bảo mật

# 3. Thành phần
- Mỗi K8s cluster bao gồm một master node (control plane) và 1 hoặc nhiều worker node

    <image src="https://images.viblo.asia/7f2a7e35-c0d8-42c2-828b-8309ea1a48f6.png" width="500">

- Master node bao gồm 4 thành phần chính
  - API server: thành phần chính để giao tiếp với các thành phần khác
  - Controller manager: gồm nhiều controller riêng cụ thể cho từng resource và thực hiện các chức năng cụ thể cho từng resource trong kube như create pod, create deploy, ...
  - Scheduler: schedule ứng dụng tới node nào
  - Etcd: là một database để lưu trạng thái và resource của cluster

- Master node chỉ có nhiệm vụ control state của cluster, nó không có ứng dụng chạy trên đó, ứng dụng sẽ chạy trên các worker node. Mỗi worker node gồm 3 thành phần chính:
  - Container runtime (docker, rkt hoặc nền tảng khác): chạy container
  - Kubelet: giao tiếp với api server
  - Kubernetes Service Proxy (kube-proxy): quản lý network và trafic của các ứng dụng trong worker node

## 3.1. K8s Pod
- Là thành phần cơ bản nhất để deploy và chạy một ứng dụng. Pod dùng để nhóm và chạy một hoặc nhiều container lại với nhau trên cùng một worker node, những container trong cùng một pod sẽ chia sẻ tài nguyên với nhau
- Thông thường chỉ nên run một pod với một container

    <image src="https://d33wubrfki0l68.cloudfront.net/5cb72d407cbe2755e581b6de757e0d81760d5b86/a9df9/docs/tutorials/kubernetes-basics/public/images/module_03_nodes.svg" width="500">