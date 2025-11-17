data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = true

  tags = {
    Name = "${var.name_prefix}-web"
  }
}

output "instance_id" {
  value       = aws_instance.this.id
  description = "WebサーバーEC2のインスタンスID"
}

output "public_ip" {
  value       = aws_instance.this.public_ip
  description = "WebサーバーEC2のパブリックIP"
}


