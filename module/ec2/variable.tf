variable "instance_ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)  
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}