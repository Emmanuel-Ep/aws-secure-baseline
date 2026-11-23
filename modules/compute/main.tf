data "aws_ami" "myami" {
  most_recent      = true

  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

}

resource "aws_instance" "my_server" {
    ami                     = data.aws_ami.myami.id
    for_each          = var.instance_number
    instance_type = var.instance_type
    iam_instance_profile = var.instance_profile

    root_block_device {
        encrypted = true
        volume_type = var.volume_type

        tags = {
            Name = "${var.project_name}-ebs-volume"
        }
    }
  user_data = templatefile("${path.module}/userdata.sh", {
  efs_id = aws_efs_file_system.efs_demo.id
})
    subnet_id = var.subnet_id
    vpc_security_group_ids = [var.security_group_id]
    depends_on = [aws_efs_mount_target.efs_mt]

    tags = { 
        Name = "ec2"
    }
}


resource "aws_efs_file_system" "efs_demo" {
    encrypted = true
    performance_mode = "generalPurpose"
    throughput_mode = "elastic"

  tags = {
    Name = "${var.project_name}-efs-demo"
  }
}

resource "aws_security_group" "efs_sg" {
    name = "allow NFS"
    description = "Allow instance traffic to port 2049"
    vpc_id = var.vpc_id

    ingress {
        from_port = 2049
        to_port = 2049
        protocol = "tcp"
        security_groups = [var.security_group_id]
    }

}

resource "aws_efs_mount_target" "efs_mt" {
    file_system_id = aws_efs_file_system.efs_demo.id
    subnet_id = var.subnet_id
    security_groups = [aws_security_group.efs_sg.id]

}