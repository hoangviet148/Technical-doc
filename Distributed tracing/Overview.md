- Distributed tracing là một phương pháp dùng để profile và giám sát ứng dụng, đặc biệt là các ứng dụng được xây dựng sử dụng kiến trúc microservices. Phương pháp này giúp xác định xem nơi nào xảy ra lỗi và nơi nào gây ra poor performance
-> trong kiến trúc microservices một single request hoặc một transaction có thể đi qua hàng trăm services và trở nên khó khăn để xác định nguyên nhân nếu có lỗi. Với distributed tracing, thì ta có thể có một giao diện tập trung để có thể quan sát các mà các request đi qua các service


- OpenTracing
  - là tập hợp các APIs và thư viện dùng để đo các thông số của ứng dụng
  <image src="https://d33wubrfki0l68.cloudfront.net/77b7ee2242b15f68c8ec5c76d618731b07806e36/1f2b0/img/blog/2021/09/opentracing_ecosystem.png">

- Jaeger 
  - là một end-to-end distributed tracing tool được xây dựng bởi Uber và sau đấy opensource
  - cung cấp các thư viện giúp đo các thông số được xấy dựng dựa trên các tiêu chuẩn của openTracing
  - cung cấp 2 kiểu storage backend
    - Cassandra
    - Elastic search
  - Một số thành phần: spans, tags, scopes, tracers
      - Span encapsulates: 
        - an operation name
        - a start and finish timestamp
        - a set of key:value span tag
        - a set of key:value span logs
        - a span context

