terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#configure custom VPC
resource "aws_vpc" "mytf-vpc" {
  cidr_block       = "10.0.0.0/16"
 
  tags = {
    Name = "mytf-vpc"
  }
}

#configure subnet
#configure public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.mytf-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "TFPublic-subnet"
  }
}
#configuring private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.mytf-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "TFPrivate-subnet"
  }
}

#configure Internet Gateway
resource "aws_internet_gateway" "internetgateway" {
  vpc_id = aws_vpc.mytf-vpc.id

  tags = {
    Name = "TF-InternetGateway"
  }
}

#configuring EIP for NAT Gateway
resource "aws_eip" "eip" {
}

#configuring NAT Gateway
resource "aws_nat_gateway" "natgateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "TF-NATGateway"
  }
}

#configuring route table for public subnet
resource "aws_route_table" "pubsubrt" {
  vpc_id = aws_vpc.mytf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetgateway.id
  }
tags = {
    Name = "TFPubsubrt"
  }
}

#assosiating routetable and public subnet
resource "aws_route_table_association" "TFasso-pubsub2rt" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.pubsubrt.id
}

#Launching EC2 instance inside public subnet
resource "aws_instance" "ec2vm" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public-subnet.id  
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "TF-VPC"
  }
}
