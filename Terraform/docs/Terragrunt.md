- Vấn đề: code vẫn bị lặp lại, chưa có cái nhìn tổng quan về toàn bộ hạ tầng, tổ chức repo gần như phẳng, không phân cấp.

- Tính năng:
  - Phụ thuộc rõ ràng: chia sẻ state một cách rõ ràng
    ```
    dependency "vpc" {
        config_path = "../../infrastructure/vpc"
    }
    dependency "external_alb" {
        config_path = "../../infrastructure/load-balancer/external-alb"
    }
    dependency "external_security_group" {
        config_path = "../../infrastructure/load-balancer/external-security-group"
    }
    vpc_id   = depedency.vpc.outputs.vpc_id
    private_subnet_ids = depedency.vpc.outputs.private_subnet_ids
    load_balancer_arn  = depedency.external_alb.outputs.lb_arn
    security_group_id = depedency.external_security_group.outputs.sg_id
    ```
    &rarr; tạo một dependency tree và chạy các lệnh theo thứ tự thích hợp để tất cả các phụ thuộc cần thiết đều có sẵn tại thời điểm thực thi

  - Hỗ trợ biến môi trường

  - Generate: tránh lặp code
    ```
    # Creates provider.tf 
    generate "providers" {
        path      = "providers.tf"
        if_exists = "overwrite"
        contents = <<EOF
    provider "aws" {
        region = var.aws_region
    }
    variable "aws_region" {
        description = "AWS region to create infrastructure in"
        type = string
    }
    terraform {
        backend "s3" {
        }
    }
    EOF
    }
    ```

  - read_terragrunt_config: loại bỏ code terragrunt lặp lại

  - Quản lý trạng thái từ xa động
    - Chuyển cấu hình S3 key làm các biến => hạn chế vì không hỗ trợ các đầu vào động như biến hoặc biểu thức
    - terragrrunt cho phép tạo ra các đường dẫn key động
      ```
      remote_state {
        backend = "s3"
        config = {
          bucket  = "medium-terragrunt-example"
          key     = "terragrunted/${path_relative_to_include()}.tfstate"
          region  = "eu-west-1"
          encrypt = true
        }
      }
      ```

  - Tổ chức code terraform
    - Vì cấu hình state có thể quản lý một cách động nên bạn có thể tạo và develop các module với sự liên kết rời rạc, tạo thuận tiện cho việc tổ chức code Terraform

  - Thực thi các lệnh terraform trên nhiều module một lúc
    ```
    terragrunt run-all
    ```
        