# Pod trong k8s
Container thường hướng tới việc giải quyết một vấn đề đơn lẻ, được xác định trong phạm vi hẹp, như là một microservice. Nhưng trong thế giới thực, các vấn đề đòi hỏi nhiều container cho một giải pháp hoàn chỉnh => kết hợp nhiều container trong 1 pod duy nhất và ý nghĩa đối với giao tiếp giữa các container

# Khái niệm K8s Pod
- Là đơn vị nhỏ nhất có thể được triển khai và quản lý bởi k8s
- Một Pod có thể có nhiều container và chúng giao tiếp với nhau dưới dạng các cổng khác nhau trên máy chủ cục bộ

# Tại sao k8s sử Pod làm đơn vị triển khai nhỏ nhất chứ không phai container
- Một container có thể là một docker container nhưng cũng có thể là một rkt container hoặc một VM được quản lý bởi virtlet. Mỗi thứ trong này lại có các yêu cầu khác nhau
- Để quản lý một container, k8s cần bổ sung nhiều thông tin như restart policy, vấn đề cần làm với container khi nó terminate, hoặc một liveness probe. Thay vì quá tải việc bổ sung thuộc tính cho những điều trên thì k8s sử dụng một thực thể mới là Pod, một container logic (Wrap) có một hoặc nhiều container để quản lý như một thực thể duy nhất

# Tại sao có thể có nhiều container trong 1 Pod
- Các container trên một Pod chạy trên một logical host, chúng sử dụng chung một namespace (chung IP và port space) và cùng IPC namespace. Chúng có thể sử dụng chung Share volume => làm cho container giao tiếp hiệu quả, đảm bảo data locality. Ngoài ra, Pod cho phép bạn quản lý nhiều application container được kết hợp chặt chẽ dưới dạng single unit
- Lợi ích của việc chạy 1 ứng dụng bởi nhiều container
  - Nếu nhiều Process trên một container thì gây khó khăn cho việc khắc phục bởi log các process sẽ trộn vào nhau và gây khó cho việc quản lý process lifecycle ví dụ như quản lý "zombie processs"
  - Làm cho ứng dụng đơn giản, minh bạch hơn và cho phép decoupling software dependencied
  - Ngoài ra các container chi tiết hơn có thể được sử dụng lại giữa các nhóm 

# Các trường hợp sử dụng Pod có nhiều container
Mục đích chính của Pod có nhiều container là hỗ trợ quản lý nhiều process cùng trợ giúp cho một ứng dụng chính. Một số trường hợp (pattern) sử dụng process trợ giúp trong Pod
- Sidebar containers
- Proxies, bridges và adapters

# Kết nối các container trong 1 Pod