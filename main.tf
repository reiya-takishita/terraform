terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# VPC の CIDR ブロックを変更
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = { Name = "three-tier-vpc-test" }
}

# Public サブネット A (ap-northeast-1a)
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az_a
  tags                    = { Name = "public-a" }
}

# Public サブネット B (ap-northeast-1b) を追加
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az_b
  tags                    = { Name = "public-b" }
}

# Private App サブネット A (ap-northeast-1a)
resource "aws_subnet" "private_app_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_a_cidr
  availability_zone = var.az_a
  tags              = { Name = "private-app-a" }
}

# Private App サブネット B (ap-northeast-1b) を追加
resource "aws_subnet" "private_app_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_b_cidr
  availability_zone = var.az_b
  tags              = { Name = "private-app-b" }
}

# Private DB サブネット A (ap-northeast-1a)
resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_a_cidr
  availability_zone = var.az_a
  tags              = { Name = "private-db-a" }
}

# Private DB サブネット B (ap-northeast-1b) を追加
resource "aws_subnet" "private_db_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_b_cidr
  availability_zone = var.az_b
  tags              = { Name = "private-db-b" }
}
# Internet Gateway を追加し、VPC にアタッチ
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "three-tier-igw" }
}

# NAT Gateway 用の EIP を追加
resource "aws_eip" "nat_gw" {
  depends_on = [aws_internet_gateway.main] # IGWが先に作成されるように依存関係を設定
  tags       = { Name = "three-tier-nat-eip" }
}
# NAT Gateway を Public Subnet に配置
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.public_a.id # Public Subnet A に配置
  depends_on    = [aws_internet_gateway.main]
  tags          = { Name = "three-tier-nat-gw" }
}

# Public サブネット用のルーティングテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = { Name = "public-route-table" }
}

# Public サブネット A をルーティングテーブルに関連付け
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# Public サブネット B をルーティングテーブルに関連付け
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# Private App サブネット用のルーティングテーブル
resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = { Name = "private-app-route-table" }
}

# Private App サブネット A をルーティングテーブルに関連付け
resource "aws_route_table_association" "private_app_a" {
  subnet_id      = aws_subnet.private_app_a.id
  route_table_id = aws_route_table.private_app.id
}

# Private App サブネット B をルーティングテーブルに関連付け
resource "aws_route_table_association" "private_app_b" {
  subnet_id      = aws_subnet.private_app_b.id
  route_table_id = aws_route_table.private_app.id
}

# Private DB サブネット用のルーティングテーブル
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = { Name = "private-db-route-table" }
}

# Private DB サブネット A をルーティングテーブルに関連付け
resource "aws_route_table_association" "private_db_a" {
  subnet_id      = aws_subnet.private_db_a.id
  route_table_id = aws_route_table.private_db.id
}

# Private DB サブネット B をルーティングテーブルに関連付け
resource "aws_route_table_association" "private_db_b" {
  subnet_id      = aws_subnet.private_db_b.id
  route_table_id = aws_route_table.private_db.id
}

resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB のサブネットに public_b を追加し、マルチAZに対応
resource "aws_lb" "alb" {
  name               = "three-tier-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}
resource "aws_lb_target_group" "tg" {
  name     = "three-tier-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_launch_template" "app_lt" {
  name          = "app-lt"
  image_id      = "ami-0e1d06225679bc1c5"
  instance_type = "t3.micro"
  user_data     = base64encode("#!/bin/bash\n amazon-linux-extras enable nginx1 && yum clean metadata && yum -y install nginx && systemctl enable nginx && systemctl start nginx")
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = [aws_subnet.private_app_a.id, aws_subnet.private_app_b.id] # ASG のサブネットに private_app_b を追加
  target_group_arns         = [aws_lb_target_group.tg.arn]
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
}

# RDS サブネットグループに private_db_b を追加し、マルチAZに対応
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet"
  subnet_ids = [aws_subnet.private_db_a.id, aws_subnet.private_db_b.id]
}
resource "aws_db_instance" "db" {
  allocated_storage    = 20
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "examplepass1234!" # sample only
  skip_final_snapshot  = true
}

# Public サブネット用の Network ACL
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "public-nacl" }

  # Inbound Rules
  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Outbound Rules
  egress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
}

# Public サブネット A と NACL を関連付け
resource "aws_network_acl_association" "public_a" {
  subnet_id        = aws_subnet.public_a.id
  network_acl_id = aws_network_acl.public.id
}

# Public サブネット B と NACL を関連付け
resource "aws_network_acl_association" "public_b" {
  subnet_id        = aws_subnet.public_b.id
  network_acl_id = aws_network_acl.public.id
}

# Private App サブネット用の Network ACL
resource "aws_network_acl" "private_app" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "private-app-nacl" }

  # Inbound Rules
  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.public_subnet_a_cidr
    from_port  = 80
    to_port    = 80
  }
  ingress {
    rule_no    = 101
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.public_subnet_b_cidr
    from_port  = 80
    to_port    = 80
  }
  ingress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.private_db_subnet_a_cidr
    from_port  = 1024 # Ephemeral port for DB return traffic
    to_port    = 65535
  }
  ingress {
    rule_no    = 111
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.private_db_subnet_b_cidr
    from_port  = 1024 # Ephemeral port for DB return traffic
    to_port    = 65535
  }
  ingress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0" # NAT Gateway からの戻りトラフィック
    from_port  = 1024
    to_port    = 65535
  }

  # Outbound Rules
  egress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.private_db_subnet_a_cidr
    from_port  = 3306
    to_port    = 3306
  }
  egress {
    rule_no    = 101
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.private_db_subnet_b_cidr
    from_port  = 3306
    to_port    = 3306
  }
  egress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0" # NAT Gateway 経由でのインターネットアクセス
    from_port  = 443
    to_port    = 443
  }
  egress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.public_subnet_a_cidr
    from_port  = 1024 # ALB への戻りトラフィック
    to_port    = 65535
  }
  egress {
    rule_no    = 121
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.public_subnet_b_cidr
    from_port  = 1024 # ALB への戻りトラフィック
    to_port    = 65535
  }
  egress {
    rule_no    = 130
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0" # NAT Gateway からの戻りトラフィック
    from_port  = 1024
    to_port    = 65535
  }
}

# Private App サブネット A と NACL を関連付け
resource "aws_network_acl_association" "private_app_a" {
  subnet_id        = aws_subnet.private_app_a.id
  network_acl_id = aws_network_acl.private_app.id
}

# Private App サブネット B と NACL を関連付け
resource "aws_network_acl_association" "private_app_b" {
  subnet_id        = aws_subnet.private_app_b.id
  network_acl_id = aws_network_acl.private_app.id
}

# Private DB サブネット用の Network ACL
resource "aws_network_acl" "private_db" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "private-db-nacl" }

  # Inbound Rules
  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.private_app_subnet_a_cidr
    from_port  = 3306
    to_port    = 3306
  }
  ingress {
    rule_no    = 101
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.private_app_subnet_b_cidr
    from_port  = 3306
    to_port    = 3306
  }
  ingress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0" # NAT Gateway からの戻りトラフィック
    from_port  = 1024
    to_port    = 65535
  }

  # Outbound Rules
  egress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.private_app_subnet_a_cidr
    from_port  = 1024 # App への戻りトラフィック
    to_port    = 65535
  }
  egress {
    rule_no    = 101
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.private_app_subnet_b_cidr
    from_port  = 1024 # App への戻りトラフィック
    to_port    = 65535
  }
  egress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0" # NAT Gateway 経由でのインターネットアクセス
    from_port  = 443
    to_port    = 443
  }
  egress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0" # NAT Gateway からの戻りトラフィック
    from_port  = 1024
    to_port    = 65535
  }
}

# Private DB サブネット A と NACL を関連付け
resource "aws_network_acl_association" "private_db_a" {
  subnet_id        = aws_subnet.private_db_a.id
  network_acl_id = aws_network_acl.private_db.id
}

# Private DB サブネット B と NACL を関連付け
resource "aws_network_acl_association" "private_db_b" {
  subnet_id        = aws_subnet.private_db_b.id
  network_acl_id = aws_network_acl.private_db.id
}

# S3メインバケットを作成
resource "aws_s3_bucket" "this" {
  bucket = var.s3_bucket_name
  tags   = var.s3_bucket_tags
}

# S3バケットのすべてのパブリックアクセスをブロック
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3バケットのデフォルト暗号化にSSE-S3 (AES256) を設定
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "alb_dns_name" { value = aws_lb.alb.dns_name }
