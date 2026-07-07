data "aws_ami" "amazon_linux" {
    most_recent = true
    
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["al2023-ami-*-x86_64"]
    }
}

resource "aws_instance" "my_first_demo"{
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"

    tags = {
        Name = "ec2_server"
    }
}