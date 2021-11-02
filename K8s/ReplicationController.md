- Đặt vấn đề: trong thực tế sẽ không chạy pod trực tiếp, vì nó sẽ gặp nhiều hạn chế mà sẽ tạo những resource khác như replicationcontrollers hoặc ReplicaSets và nó sẽ tự động quản lý pod

## Replicationcontroller
- Là 1 resource sẽ tạo và quản lý pod và số lượng pod nó quản lý không quản lý không thay đổi và kept running. RC sẽ tạo số lượng pod bằng với số ta chỉ định ở thuộc tính replicas và quản lý pod thông qua labels của pod

<image src="https://images.viblo.asia/18bf20c6-7160-4987-9fae-66ec6edc6d33.png">

- Pod sẽ giám sát container và tự động restart khi container fail nhưng trong TH toàn bộ worker node fail thì hệ thống sẽ down.
=> Nếu cluster nhiều hơn 1 worker node, RC sẽ đảm bảo số lượng Pod mà nó tạo ra không đổi. Ví dụ khi tạo 1 Rc với số lượng replicas = 1, RC sẽ tạo 1 pod và giám sát nó, khi worker node die thì RC sẽ phát hiện số lượng pod = 0 và nó sẽ tạo ra thằng pod ở một worker node khác để đạt lại số lượng = 1

<image src="https://images.viblo.asia/e47d1df7-93cb-48fd-abd1-775f200665c1.png">

- Sử dụng Rc để chạy pod giúp ứng dụng HA nhất có thể. Ngoài ra có thể tăng performance của ứng dụng bằng cách chỉ định số lượng replicas trong RC để RC tạo ra nhiều pod chạy cùng 1 version => request của user sẽ được gửi tới 1 trong 3 pod này, giúp quá trình xử lý tăng gấp 3

<image src="https://images.viblo.asia/a6db7abf-1452-4463-8345-43f9b640b307.png">

- Cấu trúc của 1 file config RC gồm 3 phần chính:
  - label selector: chỉ định pod nào được giám sát
  - replica count: số lương pod được tạo
  - pod tempalte: config của pod được tạo ra

- Thay đổi template pod: có thể thay đổi template của pod và cập nhật lại RC nhưng nó sẽ không apply cho những pod hiện tại. Muốn cập nhật lại template mới thì phải xóa hết pod để RC tạo ra pod mới hoặc xóa RC và tạo lại

<image src="https://images.viblo.asia/52e144c9-0c89-47f9-8a64-618556e02cb4.png">

## ReplicaSets
- RS và RC sẽ hoạt động tương tự nhau. Nhưng RS linh hoạt hơn ở phần label selector, trong khi label selector thằng RC chỉ có thể chọn pod mà hoàn toàn giống với label nó chỉ định, thì thằng RS sẽ cho phép dùng một số expressions hoặc matching để chọn pod nó quản lý.
- Ví dụ, thằng RC không thể nào match với pod mà có env=production và env=testing cùng lúc được, trong khi thằng RS có thể, bằng cách chỉ định label selector như env=* . Ngoài ra, ta có thể dùng operators với thuộc tính matchExpressions như sau:
```
selector:
  matchExpressions:
    - key: app
      operator: In
      values:
        - kubia
```
- Có 4 operators cơ bản là: In, NotIn, Exists, DoesNotExist

## DaemonSets
- Dùng để chạy chính xác một pod trên một worker node
- Đây là một resource khác của kube, giống như RS, nó cũng sẽ giám xác và quản lý pod theo lables. Nhưng thằng RS thì pod có thể deploy ở bất cứ node nào, và trong một node có thể chạy mấy pod cũng được. Còn thằng DaemonSets này sẽ deploy tới mỗi thằng node một pod duy nhất, và chắc chắn có bao nhiêu node sẽ có mấy nhiêu pod, nó sẽ không có thuộc tính replicas

<image src="https://images.viblo.asia/f3e48546-9b72-41bf-aa74-79cc354f06e6.png">

- Ứng dụng của thằng DaemonSets này sẽ được dùng trong việc logging và monitoring. Lúc này thì chúng ta sẽ chỉ muốn có một pod monitoring ở mỗi node