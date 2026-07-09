data "aws_ami" "my_ami" {
    most_recent = true

    owners = ["amazon"]

    filter {
        name = "name"
        values = ["al2023-ami-*-x86_64"]
    }
}

resource "aws_instance" "my_first_demo"{
    ami = data.aws_ami.my_ami.id
    instance_type = "t2.micro"
    user_data = file("${path.module}/userdata.sh")
    vpc_security_group_ids = [aws_security_group.web_sg.id]

    tags = {
        Name = "ec2_server"
    }
}


resource "aws_security_group" "web_sg" {
    name = "web-sg"
    description = "Allow HTTP inbound, all outbound"

    ingress {
        description = "HTTP from anywhere"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "web_vpc"
    }
}

resource "aws_subnet" "my_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us_east-1a"
    map_public_ip_on_launch = true
}

   
    