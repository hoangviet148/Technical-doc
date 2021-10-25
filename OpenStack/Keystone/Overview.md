# 1. Các khái niệm trong Keystone
## 1.1. Project
- Là sự gom gộp, cô lập các nguồn tài nguyên (server, images, ...)
- Các project tự mình không có user, các user và group muốn truy cập tài nguyên trong project phải được gán role để quy định tài nguyên được phép truy cập trong project (**role asignment**)
## 1.2. Domain
- Cô lập khung nhìn về tập các project và user (cũng như user group) đối với mỗi tổ chức riêng biệt, tránh việc user có khung nhìn toàn cục gây ra xung đột không mong muốn về username giữa các tổ chức khác nhau trong cùng một hệ thống cloud
- Domain là tập hợp gồm các user, group, project
- Phân chia tài nguyên vào các "kho chứa" để sử dụng độc lập với mỗi tổ chức
- Mỗi domain có thể coi là sự phân chia về mặt logic giữa các tổ chức, doanh nghiệp trên cloud
## 1.3. Users và User Groups (Actor)
- User: thực thể được phép truy cập vào tài nguyên cloud đã đươck cô lập bởi domain và project
Group: tập hợp các user
- User và user group được phép "common across domain", nghĩa là trên các domain khác nhau, tên user và user group của các domain này có thể giống nhau. Tuy nhiên mỗi user và user group đều có một định danh duy nhất (UUID)
- Role: các role gán cho user và user group trên các domain và project có giới hạn toàn cục (global scoped) chứ không phải giới hạn domain (trong bản Liberty, các phiên bản trong tương lai có thể khác)

    <image src="https://camo.githubusercontent.com/980b533f490615f700e7a8aef5d2dcee724c4ceb5fe64949a831eeabbe7eb546/687474703a2f2f692e696d6775722e636f6d2f6a4b4a454644682e706e67" width="500">

## 1.4. Roles
Khái niệm gắn liên với Authorization (ủy quyền), giới hạn các thao tác vận hành hệ thống và nguồn tài nguyên mà user được phép. Role được gán cho user và nó được gán cho user đó trên một project cụ thể. ("assigned to" user, "assigned on" project)

## 1.5. Assignment
Khái niệm "role assignment" thể hiện sự kết nối giữa một actor(user và user group) với một actor(domain, project) và một role. Role assignment được cấp phát và thu hồi, và có thể được kế thừa giữa các user và group trên project của domains. (do role có giới hạn toàn cục - global scoped)

## 1.6. Targets
Khái niệm chỉ project hoặc domain, nơi mà role được gán cho người dùng trên đó (assigned on).
## 1.7. Token
Có thể coi là chìa khóa để truy cập tài nguyên trên cloud. Token được sử dụng để xác thực tài khoản người dùng và ủy quyền cho người dùng khi truy cập tài nguyên (thực hiện các API call).
Token bao gồm:
ID: định danh duy nhất của token trên cloud
payload: là dữ liệu về người dùng (user được truy cập trên project nào, danh mục các dịch vụ sẵn sàng để truy cập cùng với endpoints truy cập các dịch vụ đó), thời gian khởi tạo, thời gian hết hạn, etc.
## 1.8. Catalog
Là danh mục các dịch vụ để người dùng tìm kiếm và truy cập. Catalog chỉ ra các endpoints truy cập dịch vụ, loại dịch vụ mà người dùng truy cập cùng với tên tương ứng, etc. Từ đó người dùng có thể request khởi tạo VM và lưu trữ object.

# 2. Identity
## 2.1. SQL
Tùy chọn để lưu trữ các actor (user và group), hỗ trợ các hệ quản trị cơ sở dữ liệu như: MySQL, PostgreSQL, DB2, etc. Việc thiết lập sử dụng SQL nằm trong file cấu hình keystone.conf.
- Ưu điểm:
  - Dễ dàng cài đặt
  - Quản lý các user và group thông qua OpenStack APIs
- Nhược điểm:
  - Keystone không thể thiết lập trở thành Identity Provider hỗ trợ xác thực tập trung khi sử dụng SQL
  - Hỗ trợ cả mật khẩu yếu (không luân chuyển password để xác thực được, không khôi phục được password)
  - Hầu hết doanh nghiệp đều có một LDAP server để lưu thông tin nhân viên
  - Identity silo
## 2.2. LDAP
- LDAP là tùy chọn khác để thu thập và lưu trữ actor. Keystone truy cập LDAP giống như nhiều ứng dụng khác sử dụng LDAP (System Login, Email, Web Apps, etc.).
- Thiết lập cho Keystone kết nối với LDAP trong file keystone.conf.
- LDAP thiết lập cho Keystone liệu có quyền "write" dữ liệu vào LDAP hay chỉ có quyền "read"
- Trường hợp lý tưởng là LDAP chỉ thực hiện thao tác read, nghĩa là hỗ trợ tìm kiếm user, group và thực hiện xác thực
- Ưu điểm:
  - Không cần duy trì bản sao của các tài khoản người dùng
Keystone không cấu hình LDAP để trở thành identity provider
- Nhược điểm:
  - Các service accounts (nova, glance, swift, etc.) vẫn cần lưu trữ ở đâu đó, bởi LDAP admin không muốn những account này lưu trữ trong LDAP
  - Keystone vẫn có thể "thấy" được mật khẩu người dùng, bởi mật khẩu nằm trong yêu cầu xác thực. Keystone đơn giản chỉ chuyển tiếp những yêu cầu này đi. Tuy nhiên trường hợp lý tưởng nhất vẫn là Keystone không được "thấy" password nữa.
## 2.3. Multiple Backends
- Hỗ trợ từ bản Juno với Identity API version 3.
- Triển khai các backend riêng biệt cho mỗi domain Keystone. Trong đó "default" domain sử dụng SQL backend để lưu trữ các service account. (tài khoản tương ứng với các dịch vụ khác trong OpenStack tương tác với Keystone). LDAP backends có thể hosted trên domain riêng biệt của họ. Thông thường LDAP của quản trị hệ thống cloud OpenStack khác với LDAP của từng công ty. Do đó trên mỗi domain của công ty riêng biệt thường triển khai quản lý thông tin nhân viên của họ.
- Ưu điểm:
  - Hỗ trợ đa hệ thống LDAPs cho nhiều tài khoản user, còn SQL lưu trữ service accounts, LDAP lưu thông tin
  - Tận dụng lợi thế của LDAP
- Nhược điểm:
  - Cài đặt sử dụng phức tạp hơn SQL
  - Xác thực các tài khoản người dùng trong phạm vị domain
## 2.4. Identity Providers
- User lưu trong Keystone, được xem như các tài khoản không bền vững (ephemeral)
- Các federated user sẽ có các thuộc tính map với role của group
- Đứng về góc nhìn của Keystone, các identity provider là tài nguyên lưu trữ danh tính, có thể là hệ thống backend như (LDAP, AD, MongoDB) hoặc các tài khoản mạng xã hội như (Google, Facebook, Twitter). Thông qua hệ thống Identity Manager trên mỗi domain, các thuộc tính của người dùng sẽ được đưa về các định danh federated có định dạng tiêu chuẩn như SAML, OpenID Connect.
- Ưu điểm
  - Tận dụng hạ tầng và phần mềm có sẵn để xác thực người dùng và thu thập thông tin người dùng
  - Tách biệt Keystone và vấn đề xử lý thông tin định danh
Mở cửa cho mục đích liên kết giữa các hệ thống cloud, hybrid cloud.
  - Keystone không còn "thấy" được user password nữa
  - Identity provider hoàn toàn thực hiện việc xác thực
- Nhược điểm: cài đặt các identity source rất phức tạp.
## 2.5. Các use cases sử dụng Identity Backends

# 3. Authentication
## 3.1. Password
## 3.2. Token

# 4. Access management and authorization
# 5. Backends và Services
# 6. FAQs
Một số chú ý và câu hỏi thường gặp với keystone
- Domain vs Region:
  - Domain tách biệt về mặt tài nguyên giữa các chủ sở hữu của các project và identity source (LDAP, SQL)
  - Region đại diện bởi vị trí địa lý như: US-West, USS-East
- Mỗi người dùng chỉ nằm trong một domain, tên user có thể trùng nhau giữa các project khác nhau. Tuy nhiên mỗi user có một định danh UUID duy nhất
- Khái niệm scope nhắc tới domain và project.
  - Unscoped token: là token trả về khi đã xác thực danh tính user nhưng chưa chỉ định rõ project và domain. Token loại này dùng để truy vấn xác định xem project nào mà người dùng được phép truy cập.
  - Scoped token: xác thực với 1 project và domain cụ thể. Token này mang theo cả thông tin về role dùng để xác định các thao tác vận hành hệ thống được phép thực hiện.