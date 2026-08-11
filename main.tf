data "aws_ami" "my_ami" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "my_first_demo" {
  ami           = data.aws_ami.my_ami.id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = aws_key_pair.grace.key_name

  root_block_device {
    encrypted   = true
    volume_type = "gp3"

    tags = {
      Name = "${var.project_name}-ebs-volume"
    }
  }
  subnet_id              = module.network.public_subnet_id
  user_data              = file("${path.module}/userdata.sh")
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "ec2"
  }
}

resource "aws_key_pair" "grace" {
  key_name = "grace"
  public_key = file("${path.module}/grace.hub")
}


resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSHinbound, all outbound"
  vpc_id      = module.network.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports

    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
   
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



module "network" {
  source = "./modules/network"

  project_name = var.project_name
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone = "us-east-1a"

}




resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${var.project_name}-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "S3_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}