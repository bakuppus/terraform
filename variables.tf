variable "a_key" {}
variable "s_key" {}

variable "region" {
  default = "us-east-1"
}

variable "aws_amis"{ 
default = { 
us-east-1="ami-cd0f5cb6" 
us-east-2="ami-10547475" 
} 
}

variable "aws_keys"{
default = {
us-east-1="ubuntu1"
us-east-2="Ohio-Key"
}
} 

variable "aws_key_path"{
default = "/var/lib/jenkins/workspace/terraform-tomcat/terraform/ubuntu1.pem"
}





