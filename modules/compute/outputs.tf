output "my_instance_public_ip" {
    description = "public ip of the ec2 instance"
    value = {
        for k, v in aws_instance.my_server :
        k => "http://${v.public_ip}"
    }
}

output "my_instance_id" {
    description = "my ec2 instance id"
    value = {
        for k, v in aws_instance.my_server :
        k => v.id
    }
}