provider "aws" { 
access_key = "${var.a_key}" 
secret_key = "${var.s_key}" 
region = "${var.region}" 
}

resource "aws_security_group" "default"{ 
name="terraform-sg" 
description="Created by terraform" 
ingress{ 
from_port = 22 
to_port = 22 
protocol= "tcp" 
cidr_blocks = ["0.0.0.0/0"] 
}
ingress{ 
from_port = 80 
to_port = 80 
protocol = "tcp" 
cidr_blocks = ["0.0.0.0/0"] 
}
egress { 
from_port = "0" 
to_port = "0" 
protocol = "-1" 
#self = false
cidr_blocks = ["0.0.0.0/0"] 
}
}



resource "aws_instance" "example" { 
connection={ 
user="ubuntu" 
#key_file = "${lookup(var.aws_key_path, var.region)}"
#private_key = "${file(${lookup(var.aws_key_path, var.region)})}"
#private_key = "${file("/root/tf-codes/simple/Ohio-Key.pem")}"
private_key = "${file(var.aws_key_path)}"
#private_key = "${lookup(var.aws_key_path, var.region)}"
}
#ami = "ami-cd0f5cb6" 
ami = "${lookup(var.aws_amis, var.region)}" 
instance_type = "t2.micro" 
tags { 
Name = "terraform-example" 
}
#key_name = "ubuntu1"
#key_name = "Ohio-Key"
key_name = "${lookup(var.aws_keys, var.region)}"
security_groups = ["${aws_security_group.default.name}"]
provisioner "remote-exec" {
inline=[ 
"ping -c 10 8.8.8.8", 
"sudo apt-get -y update", 
"sudo apt-get -y install tomcat7 tomcat7-admin", 
"sudo rm -f /etc/tomcat7/tomcat-users.xml", 
"sudo wget https://raw.githubusercontent.com/bakuppus/samplejava/master/tomcat-users.xml -P /etc/tomcat7/", 

  
] 
}
}

resource "aws_eip" "ip" { 
instance = "${aws_instance.example.id}" 
provisioner "local-exec" { 
command = "echo ${aws_eip.ip.public_ip} > ip_address.txt" 

}
}


