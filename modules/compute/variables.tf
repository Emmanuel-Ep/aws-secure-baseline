variable "project_name" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "instance_number" {
    type = map(string)
}

variable "volume_type" {
    type = string
}

variable "subnet_id" {
    type = string
}

variable "security_group_id" {
    type = string
}

variable "instance_profile" {
  type = string
}

variable "vpc_id"{
    type = string
}