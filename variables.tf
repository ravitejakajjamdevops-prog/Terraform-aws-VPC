variable "project" {
    type = string
}
variable "environment" {

    type = string
}
variable "vpc_cidr"{
    type = string
    default = "10.0.0.0/16"
}
variable "vpc_tags"{
    type = map
    default = {}
}
variable "Public_subnet" {
    type = list
    default = ["10.0.13.0/24","10.0.14.0/24"]
}