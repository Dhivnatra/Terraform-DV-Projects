provider "aws" {
 alias= "N_virginia"
 region= "us-east-1"
}

provider "aws" {
 alias= "Mumbai"
 region= "ap-south-1"
}

resource "aws_instance" "vm-region1"{
 provider=aws.N_virginia
 ami="ami-0b72821e2f351e396"
 instance_type="t2.micro"
 tags={
  Name="TFVM-region1"
 }
}

resource "aws_instance" "vm-region2"{
 provider=aws.Mumbai
 ami="ami-0ec0e125bb6c6e8ec"
 instance_type="t2.micro"
 tags={
  Name="TFVM-region2"
 }
}


