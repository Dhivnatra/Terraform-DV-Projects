provider "aws" {
 region=var.region
 } 

resource "aws_instance" "zentask"{
  ami           = var.ami
  instance_type = "t3.micro"

  key_name = var.key
 
  tags = {
    Name = "TF-NginxVM"
  }
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

}


